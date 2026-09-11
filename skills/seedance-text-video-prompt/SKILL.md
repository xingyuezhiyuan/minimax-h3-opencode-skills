---
name: seedance-text-video-prompt
description: "Seedance 2.0 (即梦) text-to-video specialist for pure-text ideas without reference assets. Use after the creative director routes a no-asset Seedance request. Produces a native Chinese 【风格】【时间轴】【声音】 prompt with no @参考 section. For requests over 15 seconds, output multi-segment 分段拼接 following the shared Seedance authority."
---

# Seedance Text-to-Video Prompt

Turn a text-only video concept into a precise native-Chinese Seedance prompt. Write observable audiovisual instructions rather than a plot summary or a keyword pile.

## Routing Contract

Seedance requests enter through `minimax-h3-creative-director`. If invoked directly, apply the Seedance authority below and proceed. @参考 editing/extension/reference work routes to `seedance-reference-video-prompt`; pure 首尾帧 boundary work routes to `seedance-keyframe-video-prompt`.

## Official Format Authority

Read `../seedance-prompt/SKILL.md` and `../seedance-prompt/references/seedance-format.md` before drafting. Treat those as canonical for the Seedance format and limits.

## Confirmed Multishot Handoff

When the director supplies a confirmed `multishot_plan`, treat its shot count, timing, content, framing, performance, camera, transitions, sound, and continuity decisions as already answered. Do not ask them again. Map every confirmed shot into the 【时间轴】 section without dropping or silently changing choices. If the plan overflows a single 15 s video, output it as segmented shots under the 分段拼接 strategy instead of the 4-15 s timeline.

## Mandatory Format

Always return the Seedance Chinese format:

```text
【风格】_____风格，_____秒，_____比例，_____氛围

【时间轴】
0-X秒：[镜头] + [画面] + [动作] + [特效]
X-Y秒：[镜头] + [画面] + [动作] + [特效]
...

【声音】_____配乐 + _____音效 + _____对白
```

Do not add 【参考】 when there are no reference assets. Never return a free-form paragraph or an H3 three-field prompt as the final Seedance prompt. Keep the duration within 4-15 s (or segmented output for >15 s) and the time-line prompt concise (under ~300 words) for reliable instruction following.

## Interactive Direction Check

Before drafting, ask structured questions when any of these applies: the brief is short/generic; two or more of duration, aspect ratio, visual style, scene/event progression, camera/edit rhythm, dialogue/voice, sound/music, or ending are missing; a vague phrase has multiple interpretations; or the user asks the AI to decide. Use the host's structured `question` tool. A strict yes/no question has exactly two options; every other choice question must offer at least five materially different, feasible options, with the context-specific recommendation first and `(Recommended)` in its label. Do not submit a non-binary question with fewer than five options; expand it or make it open-ended.

Prefer questions about: visual medium and style (写实/动画/水墨/科幻/复古/电影感), action/narrative intensity, camera rhythm (一镜到底 vs 时间轴多镜), sound direction, and required aspect ratio.

## Workflow

1. Extract or infer duration, aspect ratio, visual style, subjects, setting, action arc, dialogue, sound, and ending. Keep within 4-15 s, or segment when >15 s.
2. Run the interactive direction check when required. Never invent dialogue or visible text.
3. Budget actions and cuts to fit the duration; prefer one coherent action arc over many incomplete events.
4. Write 【风格】, then the 【时间轴】 stage by stage in playback order, then 【声音】.
5. Fit dialogue/lyrics to their stage; name on-screen vs off-screen speakers; quote exact speech with 引号 and mark tone.
6. For >15 s: split into ≤15 s segments; first segment normal generation, later segments begin with `将@视频1延长Xs`; record a 衔接点 (entry/exit state) for every segment boundary.
7. Run the quality gate below and return the copy-ready Chinese prompt.

## Output Contract

Return the complete Chinese Seedance prompt in a `text` code block so it can be copied directly. Provide a short 素材建议 and 使用提示 only if helpful. No mandatory English prompt or bilingual translation for Seedance.

## Quality Gate

- 【时间轴】 timestamps are strictly increasing and cover the full duration (or the full segment).
- Every stage establishes composition before describing change.
- Actions have a start, progression, and result.
- Dialogue fits its stage; cross-cut speech is explicit.
- Visible text/slogans/logo wording is quoted exactly. Do not invent any.
- 【声音】 separates 配乐, 音效, and 对白.
- No 写实真人脸部 requirement.
- The prompt stays under ~300 words and within 4-15 s (or segmented).
- No contradictory 一镜到底 plus multiple cuts.