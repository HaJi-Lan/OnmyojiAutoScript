# 来源、许可证与修改说明

本仓库是 [nearaura/OnmyojiAutoScript](https://github.com/nearaura/OnmyojiAutoScript) 的 fork，延续 [runhey/OnmyojiAutoScript](https://github.com/runhey/OnmyojiAutoScript) 的项目与作者归属。原作者和贡献者的版权、源文件署名及上游说明保持保留。

本 fork 沿用 GNU General Public License version 3（GPLv3）；完整许可证见根目录 [LICENSE](LICENSE)。本软件不提供任何担保。各第三方模块保留其原有许可证和版权文件。

## 本 fork 的修改（2026-11-14）

由 HaJi-Lan 维护的增量功能：

- 新增 Rust 原生统一桌面、任务进程管理、动态参数编辑、中文注释及配置管理。
- 新增 Python 兼容层；继续使用上游设备控制、OCR、素材和任务实现。
- 精简桌面版的日常、每周任务入口及执行范围。
- 将绘卷入口改为探索与个人突破循环，加入阈值和可选的随机切换间隔。
- 新增本地回归测试、上游兼容适配和构建辅助脚本。

`bridge/translations.upstream.zh-CN.json` 保留旧面板使用的共享中文翻译与注释，归属原项目及其贡献者，供干净源码 checkout 使用；本 fork 的文案覆盖单独存于 `bridge/translations.zh-CN.json`。

当前版本属于渐进迁移阶段，尚未实现全量 Rust 重写。原 Flutter OASX 二进制及其资源不随源码仓库重新发布。

上游源代码布局、历史及 LICENSE 保留在本 fork 中。安装目录的 `runtime/upstream/` 为独立运行 checkout；编译环境、用户配置、日志和运行时缓存不提交。

构建与使用说明见 [docs/desktop.md](docs/desktop.md)。发布二进制时，应同时提供与该版本匹配的源码和构建说明，并保留本文件及 LICENSE。
