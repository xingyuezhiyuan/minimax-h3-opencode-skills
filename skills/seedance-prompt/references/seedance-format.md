# Seedance 2.0 Official Format and Platform Reference

Source: consolidated from the Seedance 2.0 official manual (字节跳动即梦平台) and Seedance 2.0 capability documentation. Use this file as the canonical authority for Seedance prompts alongside `../SKILL.md`. If a downstream Seedance skill conflicts with this file, follow this file.

## Platform Envelope

- Generation duration: 4-15 seconds; any value in that range may be chosen.
- Output: native synthesized sound effects and background music.
- Resolution: supports 2K output.

### Input limits (全能参考 / mixed references)

- Images: ≤9 (jpeg/png/webp/bmp/tiff/gif), each < 30 MB.
- Videos: ≤3 (mp4/mov), each 2-15 s, combined video duration ≤15 s, each < 50 MB.
- Audio: ≤3 (mp3/wav), combined audio duration ≤15 s, each < 15 MB.
- Mixed references: at most 12 files total (images + videos + audio).
- Text: natural-language description.

For reference-aided generation the reference video/audio duration budget is 15 s total. Reference video consumption charges more quota.

### Hard prohibitions

- ❌ 不支持写实真人脸部素材 (uploads containing realistic human faces are rejected by the platform, for both images and videos).
- 视频延长时，生成的时长应选择「新增部分」的时长 (extend by the added duration, not the total).

## Two Entries

- 首尾帧 (first/last-frame): a first-frame image plus a prompt; optional last-frame image.
- 全能参考 (full-reference): arbitrary multimodal combination of images, videos, audio, and text.

## Output Language

Seedance prompts are native Chinese. Unlike H3, no English canonical prompt is required and no mandatory bilingual translation is produced. Exact wording that must survive verbatim stays as-is; visible text, dialogue, lyrics, brand names, and logos are quoted exactly. Chinese is used for scene, style, composition, action, camera, sound, and music description.

## Prompt Formula

```
【风格】_____ 风格，_____秒，_____比例，_____氛围
【时间轴】
0-X秒：[镜头] + [画面] + [动作] + [特效]
X-Y秒：[镜头] + [画面] + [动作] + [特效]
...
【声音】_____配乐 + _____音效 + _____对白
【参考】@图片1 _____，@视频1 _____，@音频1 _____
```

## Reference Grammar (@引用系统)

- 图片：`@图片1`-`@图片9`
- 视频：`@视频1`-`@视频3`
- 音频：`@音频1`-`@音频3`
- State each asset's purpose explicitly, for example:
  - `@图片1 作为首帧`
  - `@图片2 作为尾帧`
  - `@图片3 作为角色形象参考`
  - `@视频1 参考运镜效果`
  - `@视频2 参考动作节奏`
  - `@音频1 用于配乐`
- Do not use `@图1` interchangeably with `@图片1`: use the official labels. Prefer the canonical `@图片N` form.

## Camera Language Quick Reference

| 类别 | 关键词 |
|------|--------|
| 景别 | 大远景、远景、全景、中景、近景、特写、大特写 |
| 运镜 | 推镜头、拉镜头、摇镜头、移镜头、跟拍、环绕镜头、升降镜头、希区柯克变焦、一镜到底、手持晃动 |
| 角度 | 平视、俯拍、仰拍、低角度、鸟瞰、鱼眼、第一人称/主观视角 |

## Atmosphere Keyword Library

- 光影：逆光、侧光、顶光、伦勃朗光、剪影、轮廓光、体积光、丁达尔效应
- 色调：暖色调、冷色调、高饱和、低饱和、黑白、赛博朋克、复古胶片
- 质感：电影级、纪录片、广告质感、MV 风格、油画感、水墨感
- 情绪：温馨、紧张、悬疑、欢快、忧伤、史诗、治愈、惊悚

## Duration Strategy

### Single segment (4-15 s)

- 4-8 s: product, single action, short effect. Focus on 1-2 core shots; no timestamp timeline needed.
- 9-12 s: complete short scene. Optional timestamp timeline, 2-3 stages.
- 13-15 s: full narrative. Strongly recommend the timestamp storyboard method, 3-4 stages.

### Multi-segment (>15 s): 分段拼接 strategy

Segment-define by narrative rhythm, each ≤15 s. First segment is generated normally; every later segment uses the form `将@视频1延长Xs` (extend by the added duration). Each segment must record a 衔接点 (continuity point): the previous segment's ending state equals the next segment's starting state.

Recommended splits:

| 总时长 | 推荐分段 |
|--------|----------|
| 16-30 s | 2 段（首段 15s + 延长段） |
| 31-45 s | 3 段 |
| 46-60 s | 4 段 |
| >60 s | 拆分为独立场景分别生成，再用剪辑软件拼接 |

## Output Requirements

Deliverables per single-video request:

1. **理解确认**：confirm understood story.
2. **分镜提示词**：copy-ready Seedance prompt.
3. **素材建议**：which @参考 materials to upload and their roles.
4. **使用提示**：how to use on the 即梦 platform (@引用 syntax).

For >15s requests, output the segmented plan (each segment's prompt + 衔接点) as defined in the duration strategy.

## Quality Characteristics of a Good Prompt

- 时间轴清晰 (0-X 秒)
- 镜头语言明确 (推/拉/摇/移)
- 动作描述具体
- 多模态引用规范 (@图片X/@视频X/@音频X)
- 声音设计完整 (配乐+音效+对白)
- 参考素材标注清楚 (role per asset)
- Sensitive triggering terms avoided or rephrased
- Long-time-line prompts stay below ~300 words to preserve instruction following

## Common Failure Checks

- Reference asset without a stated purpose.
- Requesting realistic human-face assets.
- Extending with total length instead of the added length.
- 一镜到底 declared while multiple explicit cuts are specified.
- Video continuity broken between segments (missing 衔接点).
- Over-complex (>300 word) prompt with inconsistent instruction following.