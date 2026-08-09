# 使用示例

## 纯文字文生视频

```text
使用 minimax-h3-creative-director：制作一个8秒、16:9的电影感视频。雨夜东京街头，一名女侦探发现远处霓虹灯下有人跟踪她。请先补全重要创意方向，再生成提示词。
```

预期路由：`creative-director` → `text-video-prompt`。

## 人物参考一致性

```text
使用 minimax-h3-creative-director：我上传了一张角色图，希望保持人物脸部、发型和服装一致，让她从废墟中站起并召唤蓝色机械飞鸟。视频8秒。
```

预期路由：`creative-director` → `reference-video-prompt`。

## 参考图同时承担首帧语义

```text
使用 minimax-h3-creative-director：上传图片既作为人物一致性参考，也希望视频开场接近这张图片的构图。随后人物转身走向窗外。
```

预期路由仍为 `reference-video-prompt`，在提示词中表达开场画面，不使用纯关键帧模式。

## 纯首尾帧

```text
使用 minimax-h3-creative-director：两张图只分别作为第一帧和最后一帧，不需要参考其中人物、物品或风格的一致性，请设计两帧之间的运动。
```

预期路由：`creative-director` → `keyframe-video-prompt`。

## 多镜头视频

```text
使用 minimax-h3-creative-director：制作一个12秒多镜头视频，一名少年在屋顶启动机甲。请先询问镜头数量，再依次询问每个镜头的内容、景别、运镜、动作、转场和声音，每个镜头都由我确认。
```

预期路由：`creative-director` → `multishot-planner` → 最终格式化 Skill。

## 提示词审查

```text
使用 minimax-h3-creative-director 检查下面这段 H3 提示词。请指出模式、时间线、参考标签、运镜和音频结构问题，然后给出修复版本。
```

预期路由：`creative-director` → `prompt-reviewer`。
