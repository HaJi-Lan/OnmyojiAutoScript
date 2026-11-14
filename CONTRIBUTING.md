# 贡献说明

本仓库基于 [nearaura/OnmyojiAutoScript](https://github.com/nearaura/OnmyojiAutoScript)。请先阅读上游 README、任务目录内的说明和相关源文件，沿用原有 Python 命名、模块组织、UTF-8 编码及四空格缩进。

## 修改范围

- 上游 `module/`、`tasks/`、`assets/`、`deploy/` 等目录保留原项目结构和作者署名。
- Rust 桌面实现位于 `src/`；本 fork 的 Python 适配位于 `bridge/`。能在适配层完成的差异优先集中在此，便于继续同步上游。
- 修改共享任务前检查其调用者，并添加相应行为测试。
- `runtime/`、`toolkit/`、`.build-tools/`、`target/`、日志、个人配置和凭据保留在本地。
- 继承 GPLv3，不移除原许可证、版权或第三方授权声明；本 fork 的主要差异记录在 `NOTICE.md`。

## 验证

桌面版 Python 测试使用安装包内的 Python，或安装了上游依赖的 Python 3.10：

```powershell
python scripts/check_desktop.py
powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Release
```

本地 Rust 工具链和环境准备见 `docs/desktop.md`。Rust 测试运行 `cargo test --release --locked`。自动化测试与游戏实机验证应分别报告；模拟任务通过不等于实机验收完成。

## 提交

使用上游已有的 `feat(Module): ...`、`fix(Module): ...`、`docs(Module): ...` 等提交风格。描述问题、行为变化与验证结果。保留可审查的增量，不包含构建环境或账号数据。
