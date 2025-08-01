# 构建可执行文件指南

## 🚀 快速构建

### 自动构建（推荐）

使用跨平台Python脚本：
```bash
python build.py
```

### 平台特定构建

**Windows:**
```cmd
build_windows.bat
```

**Linux/macOS:**
```bash
./build_unix.sh
```

## 📋 构建依赖

构建前需要安装以下依赖：
```bash
pip install -r requirements_build.txt
```

包含的依赖：
- `PySide6>=6.5.0` - GUI框架
- `pyinstaller>=5.0.0` - 打包工具

## 📁 构建输出

构建完成后，在 `release/` 目录下会生成：

### 可执行文件
- **Claude-Config-Manager** - GUI配置管理器
- **claude-config** - 命令行配置管理工具
- **claude-switch** - 快速切换工具

### 启动脚本
- **start_gui.bat** (Windows) / **start_gui.sh** (Unix) - GUI启动脚本

### 配置和文档
- **example_config.json** - 示例配置文件
- **README.md** - 项目说明
- **QUICK_START.md** - 快速开始指南
- **IMPORT_EXPORT_GUIDE.md** - 导入导出功能指南
- **build.log** - 构建信息日志

## 🎯 使用方法

### GUI界面
```bash
# Windows
Claude-Config-Manager.exe
# 或双击 start_gui.bat

# Linux/macOS
./Claude-Config-Manager
# 或运行 ./start_gui.sh
```

### 命令行工具
```bash
# 查看帮助
./claude-config --help

# 列出提供商
./claude-config list

# 快速切换
./claude-switch qwen
./claude-switch kimi
./claude-switch zhipu
```

## 🔧 构建选项

### PyInstaller参数说明

**GUI应用 (claude_config_gui.py):**
- `--onefile` - 打包成单个可执行文件
- `--windowed` - 无控制台窗口（GUI模式）
- `--name` - 指定输出文件名
- `--icon` - 设置应用图标（Windows）
- `--add-data` - 包含数据文件
- `--hidden-import` - 显式导入PySide6模块

**命令行工具:**
- `--onefile` - 打包成单个可执行文件
- `--console` - 保留控制台窗口

## 📊 构建过程

构建脚本执行以下步骤：

1. **[1/6] 检查构建依赖** - 验证PyInstaller是否安装
2. **[2/6] 清理旧的构建文件** - 删除之前的构建输出
3. **[3/6] 构建GUI可执行文件** - 打包图形界面应用
4. **[4/6] 构建命令行工具** - 打包CLI工具
5. **[5/6] 整理构建结果** - 复制文件到release目录
6. **[6/6] 生成构建信息** - 创建构建日志

## ⚠️ 注意事项

### 构建时间
- 首次构建可能需要5-10分钟
- 后续构建会更快（缓存依赖）

### 文件大小
- GUI应用约50-80MB（包含PySide6）
- 命令行工具约10-20MB

### 兼容性
- Windows: 支持Windows 7及以上版本
- Linux: 支持主流发行版
- macOS: 支持macOS 10.14及以上版本

### 权限问题
- Linux/macOS可能需要设置执行权限：`chmod +x filename`
- Windows可能需要管理员权限运行

## 🐛 故障排除

### 常见问题

**1. PyInstaller未找到**
```bash
pip install pyinstaller
```

**2. PySide6导入错误**
```bash
pip install PySide6
```

**3. 构建失败**
- 检查Python版本（建议3.8+）
- 确保所有依赖已安装
- 查看详细错误信息

**4. 可执行文件无法运行**
- 检查文件权限
- 确保目标系统兼容
- 查看是否缺少系统依赖

### 调试模式

如需调试构建过程，可以：
1. 查看PyInstaller详细输出
2. 检查生成的.spec文件
3. 使用`--debug`参数运行可执行文件

## 📦 分发建议

### 打包分发
```bash
# 创建压缩包
tar -czf claude-config-manager-v1.0.0.tar.gz release/
# 或
zip -r claude-config-manager-v1.0.0.zip release/
```

### 安装说明
1. 解压到目标目录
2. 运行对应平台的启动脚本
3. 首次运行会创建配置目录

构建完成后，您就拥有了完全独立的可执行文件，无需在目标机器上安装Python环境！