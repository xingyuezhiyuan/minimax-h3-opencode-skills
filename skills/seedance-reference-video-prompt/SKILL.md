---
name: seedance-reference-video-prompt
description: "Seedance 2.0 (即梦) full-reference specialist for any request with image/video/audio references. Default for consistency (角色/产品/场景), 运镜与动作复刻, 创意模板/特效复刻, 音乐卡点, 视频延长, and 视频编辑, plus any ambiguous asset role. Produces a native Chinese 【风格】【时间轴】【声音】【参考】 prompt with @图片X/@视频X/@音频X references. For requests over 15 seconds, output segmented 分段拼接 following the shared Seedance authority."
---

# Seedance Full-Reference Video Prompt

Convert mixed reference assets and user intent into a native-Chinese Seedance prompt with explicit `@引用` roles and a staged timeline. Make every asset role explicit and write the target video as an audiovisual timeline.

## Routing Contract

Seedance requests enter through `minimax-h3-creative-director`. This is the default Seedance specialist for any request containing references: character/product/scene consistency, 运镜或动作复刻, 创意模板或特效复刻, 音乐卡点, 声音控制, 视频延长, 视频编辑, and ambiguous asset roles. Route to `seedance-keyframe-video-prompt` only when the user explicitly declares pure 首尾帧 boundary images with no other reusable reference role.

## Official Format Authority

Read `../seedance-prompt/SKILL.md` and `../seedance-prompt/references/seedance-format.md` before drafting. Treat those as canonical for the Seedance format, limits, and @引用 grammar.

## Confirmed Multishot Handoff

When the director supplies a confirmed `multishot_plan`, treat its shot count, timing, content, framing, performance, camera, transitions, sound, active references, and continuity decisions as already answered. Keep reference labels stable and carry the continuity ledger forward. Reopen a decision only if the plan is physically impossible, conflicts with a source asset, or exceeds the effective duration.

## Seedance Reference Semantics

- `@图片N` = image reference (consistency, 首帧/尾帧, 角色/场景/道具)
- `@视频N` = video reference (运镜/动作/节奏/转场/特效, source for 延长 or 编辑)
- `@音频N` = audio reference (配乐/音效/对白/音色)
- State each asset's purpose explicitly. Do not write vague "使用所有参考" claims.
- For 视频延长: `将@视频1延长Xs`, where X is the newly added duration; continuity must match the source.
- For 视频编辑: name what to 保留/修改/颠覆/新增 and keep the untouched part explicit.
- For 音乐卡点: align stage boundaries with the beat and reference the rhythm video/audio.

## Mandatory Format

Return the Seedance Chinese format:

```text
【风格】_____风格，_____秒，_____比例，_____氛围

【时间轴】
0-X秒：[镜头] + [画面] + [动作] + [特效]
X-Y秒：[镜头] + [画面] + [动作] + [特效]
...

【声音】_____配乐 + _____音效 + _____对白
【参考】@图片1 _____，@视频1 _____，@音频1 _____
```

Never return a free-form paragraph or an H3 six-section prompt as the final Seedance prompt. Keep 4-15 s (or segmented for >15 s) and the timeline under ~300 words.

## Interactive Direction Check

Before assigning labels or drafting, ask structured questions when the brief is sparse; gives an image plus a generic motion request; omits two or more of action progression, scene treatment, preservation priorities, visual style, camera/editing, dialogue/voice, sound/music, or endpoint; leaves a decisive reference responsibility unclear; or asks the AI to improvise. Use the host's `question` tool. A strict yes/no question has exactly two options; every other choice question must offer at least five materially different options with the recommendation first and `(Recommended)` appended. Do not submit a non-binary question with fewer than five options.

Prioritize: task relationship (参考生成/视频编辑/视频延长/组合), asset responsibility (形象/服装/场景/动作/运镜/声音), fidelity policy, prompt-level 首尾帧 anchoring, and audio policy.

## Workflow

1. Inventory every supplied image/video/audio asset and its upload order; validate the Seedance input envelope (≤9 images, ≤3 videos, ≤3 audio, ≤12 files, reference durations ≤15 s each type); run the interactive direction check when required.
2. Map what each asset contributes and assign explicit `@图片N/@视频N/@音频N` responsibility.
3. Determine applicable task types: 参考生成, 一致性控制, 运镜/动作复刻, 音乐卡点, 首尾帧, 视频延长, 视频编辑, 声音控制.
4. Build the 【时间轴】 stage by stage in playback order; prove where each important reference takes effect.
5. Write 【声音】, then 【参考】 with every asset's role.
6. For >15 s: split into ≤15 s segments (首段正常生成 + 后续 `将@视频1延长Xs`), each with a 衔接点.
7. Validate continuity, reference-provenance, temporal feasibility, and sensitivity; return the copy-ready prompt.

## Output Contract

Return the complete Chinese Seedance prompt in a `text` code block for direct copy. Provide a short 素材建议 and 使用提示 if helpful. No mandatory English prompt or bilingual translation.

## Quality Gate

- Every asset has one clear role; nothing referenced vaguely as "all materials".
- `@图片N/@视频N/@音频N` labels are stable and match upload order.
- Timeline timestamps strictly increase and cover the full duration (or segment).
- 视频延长 uses the added-duration rule; 视频编辑 names 保留/修改/颠覆/新增 explicitly.
- 音乐卡点 aligns stage boundaries with the beat.
- 声音 separates 配乐/音效/对白 and fits dialogue to its stage.
- Visible text/logo/slogan is quoted exactly; no invented wording.
- No 写实真人脸部 requirement.
- Prompt stays under ~300 words; duration within 4-15 s (or segmented).
- No contradictory 一镜到底 plus multiple cuts.