# OAS 统一桌面

本桌面版为 [nearaura/OnmyojiAutoScript](https://github.com/nearaura/OnmyojiAutoScript) 的 fork 增量实现，修改日期 2026-11-14。沿用原项目 GPLv3 和作者归属，详见根目录 `NOTICE.md` 与 `LICENSE`。

Rust 原生桌面程序，统一管理上游 OAS 的 Python 任务、配置和日志。
当前为迁移第一阶段：现有任务继续使用上游实现，界面不再依赖 Flutter OASX。

## 启动

双击根目录 `OAS.exe`。选择配置、设置设备和任务参数，再点击“启动任务”。
修改配置后点击该字段的“保存”。关闭窗口会停止本程序启动的任务及其子进程。
包含配置创建/删除、精简任务菜单、动态参数编辑、任务启动/停止、实时日志和上游同步。
任务参数下方直接显示旧面板的中文注释，长说明自动换行；注释来自上游参数描述及翻译，支持换行和本地文案覆盖。
已移除“日常任务”和“每周任务”分类及其 19 个任务：菜单不显示，参数读写、调度、任务回调和直接执行均拦截。保留御魂、肝帝专属、阴阳寮、活动任务及脚本设置。旧配置中这些任务即使已启用，也不会通过统一桌面执行。任务范围跟随上游这两个分类，规则在 `bridge/task_policy.py`，上游源码保持可同步。
点击“删除配置”立即停止对应任务并删除文件，不弹确认、不自动备份。模板也可从配置列表选择并删除；允许删除全部配置，空列表不会自动补建配置。删除模板后，点击“新增配置”会使用上游模型默认值创建配置。
尚未迁移 OASX 的图像标注、OCR 调试、配置重命名、截图预览和其他开发工具。

## 绘卷循环

“肝帝专属 → 绘卷”现为探索＋个人突破集合页，集中编辑探索、队友、战斗、御魂切换及个人突破参数，与各自任务页面共享配置。
开启该页的调度器与“绘卷模式功能”即可启动；也可在探索页开启绘卷模式并启动探索调度器。
关闭绘卷模式时，普通探索、个人突破仍按独立任务配置执行，集合页不再调度原碎片捐献功能。

循环从探索开始，券数 ≥ X 且 > 0 才转入个人突破；个人突破持续消耗余券，确认券数为零后返回探索。
X=0 时仍必须有券；识别失败不会被当作零券，也不会盲目挑战。
独立突破的最低券数不截断已开始的绘卷循环；达到单次挑战上限、失败或刷新冷却时保留突破阶段，30 秒后重试，直到用完券或手动关闭。
探索的次数或时间上限只结束本轮，绘卷模式继续下一轮探索。

原“间隔时间”替换为“切换间隔：随机等待 5～25 秒”开关，默认关闭；开启后只在探索与突破互相切换时各随机等待一次。
关闭开关立即切换；停止配置会结束整个循环。运行期间关闭绘卷模式或对应调度器，将在下一次票数检查或切换等待检查时结束循环。
集合调度器开启时，由集合任务统一调度探索与突破，避免两个入口重复执行。更新实现位于 `bridge/scrolls_cycle.py`，上游源码保持独立。

## 构建

GitHub 仓库保留上游 Python 源码的根目录布局，并在其上新增 Rust 源码和 `bridge/`。源码仓库不包含 Python 安装包、Rust 工具链或游戏账号配置。

从源码构建时，先按上游安装说明准备 Python 3.10 及 `requirements.txt` 中的依赖；将所需 Python 环境放在根目录 `toolkit/`，或使用现有统一安装布局 `runtime/upstream/toolkit/`。Rust 程序同时识别源码根目录和统一安装目录。

需要使用桌面内置上游更新时，使用独立的 `runtime/upstream/` checkout；源码根目录的 fork 变更通过 Git 正常维护。不要用强制覆盖更新开发源码。

需要 Rust；工具链、依赖缓存及辅助工具保留在 `.build-tools`，没有修改系统 PATH。项目固定使用 Rust 1.100.0；后续构建可复用本机缓存。

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Release
```

`OAS.exe --check` 可检查运行环境，不会启动游戏任务。
`OAS_DESKTOP_ROOT` 可指定安装目录；默认按可执行文件所在位置查找，不依赖启动时工作目录。

## 统一目录

```text
OAS.exe                 唯一日常启动入口
bridge/worker.py         独立的上游兼容层
runtime/upstream/        原 OAS 仓库、素材、Python、用户配置和日志
runtime/sync-history.jsonl
src/                    Rust 源码
```

程序同时识别原有 `OAS/` 布局。通过验证后可运行以下命令整合到内部目录：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/consolidate.ps1 -Apply
```

旧 `OASX/` 整合后保存在 `runtime/legacy-oasx/`，不属于新程序的运行依赖。Flutter 原版功能迁移完毕前保留用于对照。

## 上游更新

点击“同步上游”，确认停止本程序管理的任务后，执行 fetch 和快进合并。
发现本地修改、本地独有提交、非 master 分支或依赖清单变化时取消更新。
不执行 reset、clean 或强制覆盖。更新前后提交和变更路径记录在 `runtime/sync-history.jsonl`。
Python 任务与规则随上游更新；Rust 和兼容层需要独立适配上游接口变化。
更新后会重新加载上游模型。失败原因显示在窗口状态栏。

兼容层通过标准输入输出传递 JSON 行，不开放网络端口。任务进程复用上游 `Script.loop()`。
Windows Job Object 负责窗口异常退出时的子进程清理。

## 验证与后续迁移

`tests/test_bridge.py` 使用临时目录测试真实上游配置和 JSON 协议，不修改用户配置，不控制游戏。
运行 `runtime/upstream/toolkit/python.exe scripts/check_desktop.py`；源码布局使用 `toolkit/python.exe scripts/check_desktop.py`，或准备了上游依赖的 `python scripts/check_desktop.py`。
后续按设备控制、图像/OCR、调度与单项任务逐步迁移 Rust；每次以相同素材与配置验证行为。

本项目遵循 GPL-3.0；上游的许可证保留在内部仓库中。
