# Metrology Workspace 本机环境

- 配置日期：2026-11-03
- 源码：`MetrologyWorkspace/`
- 来源：https://github.com/qinyuanhao17/MetrologyWorkspace
- 标签：`v5.0.0`
- 提交：`021a8a4f267f6a4d47ac39096e2ef96af1b564c0`
- 当前本地开发分支：`local-development`（从该标签创建）
- 虚拟环境：`MetrologyWorkspace/.venv/`
- 基础解释器：`D:\Anaconda3\python.exe`，Python 3.12.7，64 位
- GUI：PyQt6 6.8.1 / Qt 6.8.2
- 已安装依赖的精确版本：`requirements-local-lock.txt`

## 启动

双击当前项目文件夹中的 `Start-MetrologyWorkspace.cmd`。终端窗口会随程序运行保留，若启动失败会显示错误，便于排查。

也可以在 PowerShell 中运行：

```powershell
Set-Location -LiteralPath 'C:\Users\13996\Documents\Cmpany Data Analysis Project\MetrologyWorkspace'
& '.\.venv\Scripts\python.exe' main.py
```

无需先激活虚拟环境。当前电脑默认 `python` 命令优先指向 Windows 应用别名，因此运行、安装依赖和测试时请使用上述完整的相对解释器路径。虚拟环境不继承 Anaconda 的第三方包，但依赖其基础 Python；不要删除或移动 `D:\Anaconda3`，移动整个项目后应重新创建虚拟环境。

## 兼容性处理

直接按上游版本范围安装时，PyQt6/Qt 6.12.0 在本机 Anaconda 解释器下出现 `QtCore` DLL 加载失败（WinError 127）。项目虚拟环境改用 PyQt6 6.8.1 / Qt 6.8.2 后，Qt 导入及应用启动自检通过。这两个版本符合上游 `requirements.txt` 的范围。上游源码和依赖文件保持原样。

更新依赖时，请保留这两个 Qt 版本，或先在新环境中验证。当前环境可以用以下命令恢复依赖：

```powershell
& '.\.venv\Scripts\python.exe' -m pip install -r '..\requirements-local-lock.txt'
& '.\.venv\Scripts\python.exe' -m pip check
```

## 日常开发和数据

在编辑器中选择 `MetrologyWorkspace\.venv\Scripts\python.exe` 作为项目解释器。源码库内的 `.venv/`、`.cache/`、运行日志及设置已由上游 `.gitignore` 排除。当前项目原有的 `Data for Test/` 保留在源码库外。

应用设置默认在 `MetrologyWorkspace/config/settings.yaml`；提醒事项默认在 `%LOCALAPPDATA%\MetrologyWorkspace\reminders.sqlite3`。测试使用独立的临时设置和提醒事项文件。

## 验证命令

完整测试必须使用项目提供的隔离 runner：

```powershell
& '.\.venv\Scripts\python.exe' run_tests.py
```

启动自检会创建五个分析工具并执行真实离线 OCR。运行时应隔离设置、恢复文件及提醒事项：

```powershell
$smokeRoot = Join-Path (Get-Location) '.cache\manual-smoke'
New-Item -ItemType Directory -Force -Path $smokeRoot | Out-Null
$env:METROLOGY_SETTINGS_PATH = Join-Path $smokeRoot 'settings.yaml'
$env:METROLOGY_RECOVERY_DIR = Join-Path $smokeRoot 'recovery'
$env:METROLOGY_REMINDERS_PATH = Join-Path $smokeRoot 'reminders.sqlite3'
& '.\.venv\Scripts\python.exe' main.py --self-test
Remove-Item Env:METROLOGY_SETTINGS_PATH, Env:METROLOGY_RECOVERY_DIR, Env:METROLOGY_REMINDERS_PATH
```

本次安装验证日志位于 `MetrologyWorkspace/.cache/`。v5.0.0 上游发布说明已记录回归测试未完全通过；本机测试结果见下方。

## 本次配置结果

- `pip check`：通过，无依赖冲突。
- `main.py --self-test`：退出码 0，包含五个工具窗口创建及真实离线 OCR。
- 实际 Windows 桌面：主界面及 Spectra Viewer 窗口已成功打开。
- 完整回归测试：按用户要求中止，未跑完，不代表全量通过。已保留部分运行日志 `.cache/full-tests.log`，无须继续运行。
- Git 工作区在安装配置后检查为干净，未修改 v5.0.0 源码。
- 桌面界面操作已在用户按 Escape 后停止。
