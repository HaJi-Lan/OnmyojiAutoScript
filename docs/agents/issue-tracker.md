# 本地任务管理

需求和任务记录在当前项目的 .scratch/ 中。

- 每项功能使用独立目录：.scratch/<feature-slug>/。
- 需求说明使用 spec.md。
- 每张实施任务单独保存为 issues/<NN>-<slug>.md，从 01 编号。
- 普通任务在文件顶部使用 Status: 记录状态，取值见 triage-labels.md。
- 讨论追加到文件底部的 ## Comments 下。
- 技能要求“发布任务”时，创建对应本地文件。
- 技能要求“获取任务”时，读取用户指定的文件。

## Wayfinding operations

- 探索地图：.scratch/<effort>/map.md，包含 Notes、Decisions-so-far、Fog。
- 子任务：.scratch/<effort>/issues/NN-<slug>.md。
- Type: 为 research、prototype、grilling 或 task。
- 探索子任务使用 Status: open、claimed 或 resolved。
- Blocked by: NN, NN 表示依赖；依赖全部 resolved 后解除阻塞。
- Frontier 为按编号排序后第一个 open、未认领且未阻塞的子任务。
- 开始前保存 claimed；完成后追加 ## Answer，保存 resolved，
  并在地图的 Decisions-so-far 中添加结论与文件链接。
