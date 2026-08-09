$ErrorActionPreference = 'Stop'

$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$skillsRoot = Join-Path $repoRoot 'skills'
$expectedSkills = @(
    'minimax-h3-creative-director',
    'minimax-h3-multishot-planner',
    'minimax-h3-text-video-prompt',
    'minimax-h3-reference-video-prompt',
    'minimax-h3-keyframe-video-prompt',
    'minimax-h3-prompt-reviewer'
)

function Assert-True {
    param(
        [Parameter(Mandatory)] [bool] $Condition,
        [Parameter(Mandatory)] [string] $Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

function Read-Utf8 {
    param([Parameter(Mandatory)] [string] $Path)
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

Write-Host 'Validating skill structure...'

$actualSkills = @(Get-ChildItem -LiteralPath $skillsRoot -Directory | Sort-Object Name)
Assert-True ($actualSkills.Count -eq $expectedSkills.Count) "Expected $($expectedSkills.Count) bundled skills, found $($actualSkills.Count)."

foreach ($skillName in $expectedSkills) {
    $skillRoot = Join-Path $skillsRoot $skillName
    $skillFile = Join-Path $skillRoot 'SKILL.md'
    $agentFile = Join-Path $skillRoot 'agents\openai.yaml'
    $referencesRoot = Join-Path $skillRoot 'references'

    Assert-True (Test-Path -LiteralPath $skillFile -PathType Leaf) "Missing $skillName/SKILL.md."
    Assert-True (Test-Path -LiteralPath $agentFile -PathType Leaf) "Missing $skillName/agents/openai.yaml."
    Assert-True (Test-Path -LiteralPath $referencesRoot -PathType Container) "Missing $skillName/references."
    Assert-True (@(Get-ChildItem -LiteralPath $referencesRoot -File).Count -gt 0) "No reference file found for $skillName."

    $content = Read-Utf8 $skillFile
    Assert-True ($content.StartsWith("---`n") -or $content.StartsWith("---`r`n")) "$skillName has invalid YAML frontmatter start."
    $nameLine = @($content -split "`r?`n" | Where-Object { $_ -match '^name:\s*' }) | Select-Object -First 1
    $declaredName = ($nameLine -replace '^name:\s*', '').Trim().Trim('"').Trim("'")
    Assert-True ($declaredName -eq $skillName) "$skillName frontmatter name does not match its directory."
    Assert-True ($content -match '(?m)^description:\s*.+$') "$skillName is missing a frontmatter description."
    Assert-True ($content -match '(?i)at least five') "$skillName does not enforce at least five non-binary options."
}

Write-Host 'Validating cross-skill workflow guards...'

$director = Read-Utf8 (Join-Path $skillsRoot 'minimax-h3-creative-director\SKILL.md')
$planner = Read-Utf8 (Join-Path $skillsRoot 'minimax-h3-multishot-planner\SKILL.md')

foreach ($skillName in $expectedSkills | Where-Object { $_ -ne 'minimax-h3-creative-director' }) {
    Assert-True ($director.Contains($skillName)) "Director does not reference downstream skill $skillName."
}

Assert-True ($director.Contains('the next interactive action must establish shot count')) 'Director does not force shot-count questioning after planner load.'
Assert-True ($director.Contains('Hard blocker: while multishot is selected')) 'Director is missing the multishot final-specialist blocker.'
Assert-True ($planner.Contains('Loading this Skill is not execution')) 'Planner does not distinguish loading from execution.'
Assert-True ($planner.Contains('six-question per-shot batch')) 'Planner is missing the six-question per-shot contract.'
Assert-True ($planner.Contains('current_shot')) 'Planner is missing sequential shot state.'
Assert-True ($planner.Contains('multishot_plan_status: confirmed')) 'Planner is missing its confirmed handoff status.'

Write-Host 'Checking for obsolete question limits...'

$markdownFiles = Get-ChildItem -LiteralPath $skillsRoot -Recurse -File -Filter '*.md'
$obsoletePatterns = @(
    'Ask 1-3',
    'ask 1-3',
    '2-3 high-impact',
    '2–3 high-impact',
    '1-3 questions',
    '1–3 questions'
)

foreach ($file in $markdownFiles) {
    $content = Read-Utf8 $file.FullName
    foreach ($pattern in $obsoletePatterns) {
        Assert-True (-not $content.Contains($pattern)) "Obsolete question-limit rule '$pattern' found in $($file.FullName)."
    }
}

Write-Host 'Validating JSON test fixtures...'

$routingCases = Read-Utf8 (Join-Path $PSScriptRoot 'routing-cases.json') | ConvertFrom-Json
$questionCases = Read-Utf8 (Join-Path $PSScriptRoot 'question-policy-cases.json') | ConvertFrom-Json
Assert-True (@($routingCases).Count -ge 6) 'Routing fixture must contain at least six cases.'
Assert-True (@($questionCases).Count -ge 3) 'Question-policy fixture must contain at least three cases.'

foreach ($case in $questionCases) {
    $optionCount = @($case.options).Count
    if ($case.binary) {
        Assert-True ($optionCount -eq 2) "Binary fixture '$($case.id)' must contain exactly two options."
    } else {
        Assert-True ($optionCount -ge 5) "Non-binary fixture '$($case.id)' must contain at least five options."
    }
}

Write-Host "Validation passed for $($expectedSkills.Count) bundled skills." -ForegroundColor Green
