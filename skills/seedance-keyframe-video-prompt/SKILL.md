---
name: seedance-keyframe-video-prompt
description: "Seedance 2.0 (即梦) 首尾帧 specialist for pure boundary-frame prompts. Use only when the creative director verifies the user explicitly declared images as literal first/last frames with no other reusable reference role. Produces a native Chinese prompt with explicit 首帧/尾帧 instruction and a continuous visual path between them. Any boundary image that also preserves identity/character/scene/style routes to seedance-reference-video-prompt."
---

# Seedance Keyframe Video Prompt

Design a continuous visual path from or toward concrete boundary frames on Seedance. Treat a boundary image as an actual target frame, not a loose style reference.

## Routing Contract

Seedance requests enter through `minimax-h3-creative-director`. Use this skill only for explicitly declared 首尾帧 boundary images (首帧仅图+提示词; optional 尾帧图). If the user did not explicitly say 首帧/尾帧/起始帧/结束帧, or if any image also preserves a reusable trait (角色/产品/场景/风格/动作/运镜), use `seedance-reference-video-prompt`.

## Official Format Authority

Read `../seedance-prompt/SKILL.md` and `../seedance-prompt/references/seedance-format.md` before drafting. Treat those as canonical for Seedance format and limits.

## Confirmed Multishot Handoff

When the director supplies a confirmed `multishot_plan`, map validated shots into the prompt while preserving exact 首帧/尾帧 alignment. Reopen only when the plan is physically impossible or contradicts a boundary image.

## Mandatory Format

Return a Seedance Chinese prompt. Express the boundary in plain Chinese rather than an H3 alignment token, for example:

```text
【风格】_____风格，_____秒，_____比例，_____氛围
【首帧】@图片1 作为起始帧
【尾帧】@图片2 作为结束帧
【时间轴】
0-X秒：[镜头] + [画面] + [动作]，沿首帧状态展开
X-Y秒：[镜头] + [画面] + [动作]，逐步向尾帧收敛
...
【声音】_____配乐 + _____音效 + _____对白
【参考】@图片1 首帧，@图片2 尾帧
```

Do not use H3's `first_frame` alignment token. Unique-帧 无尾帧时省略【尾帧】。Keep the motion path feasible within the duration (4-15 s).

## Interactive Direction Check

Before drafting, ask structured questions when the brief is sparse, the intended transformation is underspecified, or two or more of duration, motion path, visual treatment, camera strategy, sound, or landing behavior are missing. Use the host's `question` tool with the five-option minimum for non-binary choices.

Prioritize: 首帧 vs 尾帧 role for an ambiguous single image; motion strength (细微自然 motion / clear narrative action / dramatic transformation); 一镜到底 vs 时间轴多段; landing behavior (稳定定格 / 到达瞬时 / 穿过帧).

## Workflow

1. Confirm the boundary role, exact duration, and intended final action/transformation. Keep within 4-15 s (or segmented for >15 s).
2. Inspect supplied images and record identity, clothing, pose, object states, composition, camera angle, lighting, spatial relationships.
3. Define the motion path before writing prose.
4. Keep subject identity and persistent attributes consistent unless transformation is requested.
5. Prefer one continuous transition between boundary frames unless cuts are explicitly requested.
6. Validate the target boundary frame is reached at the endpoint rather than early; return the copy-ready Chinese prompt.

## Output Contract

Return the complete Chinese Seedance prompt in a `text` code block for direct copy, plus short 素材建议/使用提示 if helpful. No mandatory English prompt or bilingual translation.

## Quality Gate

- Boundary role matches the supplied images; 首帧/尾帧 instruction is explicit in Chinese.
- Initial state matches the 首帧 image when present.
- Intermediate changes are visible, causal, and feasible within the duration.
- Identity, clothing, key objects, spatial relations, and persistent colors remain continuous.
- The final pose, object state, camera angle, lighting, and composition land on the 尾帧 when present.
- The final frame is reached at the end, not held prematurely.
- Dialogue fits its stage; visible text is quoted exactly.
- No 写实真人脸部 requirement; no H3 alignment tokens in the final prompt.
- Timeline stays under ~300 words and within 4-15 s (or segmented).