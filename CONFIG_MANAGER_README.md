# Claude Code 配置管理器使用说明

## 概述

Claude Code 配置管理器是一个强大的工具，允许您轻松管理和切换不同的AI提供商配置。支持阿里云通义千问、Kimi、智谱GLM-4.5等多个提供商。

## 功能特性

- 🔧 **配置管理**: 保存和管理多个AI提供商的配置
- 🔄 **快速切换**: 一键切换不同的AI提供商
- 🖥️ **图形界面**: 直观的GUI界面，操作简单
- 📱 **命令行工具**: 支持命令行操作，适合脚本自动化
- 💾 **配置持久化**: 配置自动保存，重启后依然有效
- 🔒 **安全存储**: API Key安全存储，支持掩码显示

## 安装和设置

### 1. 自动安装（推荐）

运行安装脚本时会自动下载配置管理器：

**Linux/macOS:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

**Windows:**
```cmd
.\install_claude.bat
```

### 2. 手动安装

如果需要手动安装配置管理器：

```bash
# 下载配置管理器文件
curl -O https://raw.githubusercontent.com/sxyseo/kimi-cc/main/config_manager.py
curl -O https://raw.githubusercontent.com/sxyseo/kimi-cc/main/claude_config_gui.py
curl -O https://raw.githubusercontent.com/sxyseo/kimi-cc/main/switch_provider.py
curl -O https://raw.githubusercontent.com/sxyseo/kimi-cc/main/start_gui.py

# 安装GUI依赖（可选）
pip install PySide6
```

## 使用方法

### 1. 图形界面（推荐）

启动GUI管理器：

```bash
python claude_config_gui.py
# 或者
python start_gui.py  # 会自动检查并安装依赖
```

GUI界面功能：
- **提供商列表**: 查看所有配置的提供商
- **快速切换**: 从下拉菜单选择并切换提供商
- **添加/编辑**: 添加新提供商或编辑现有配置
- **实时状态**: 显示当前激活的提供商和环境变量
- **操作日志**: 记录所有操作历史

### 2. 命令行工具

#### 查看所有提供商
```bash
python config_manager.py list
```

#### 快速切换提供商
```bash
python switch_provider.py qwen    # 切换到通义千问
python switch_provider.py kimi    # 切换到Kimi
python switch_provider.py zhipu   # 切换到智谱GLM-4.5
```

#### 添加新提供商
```bash
python config_manager.py add custom_provider "自定义提供商" "https://api.example.com" "your_api_key" --description "我的自定义提供商"
```

#### 更新提供商配置
```bash
python config_manager.py update qwen --api_key "new_api_key"
```

#### 删除提供商
```bash
python config_manager.py delete custom_provider
```

#### 查看当前状态
#### 查看当前状态
```bash
python config_manager.py status
```

#### 导出配置
```bash
# 导出配置（不包含API Keys）
python config_manager.py export config_backup.json

# 导出配置（包含API Keys）
python config_manager.py export config_backup.json --include-keys
```

#### 导入配置
```bash
# 替换模式导入（清空现有配置）
python config_manager.py import config_backup.json

# 合并模式导入（保留现有配置）
python config_manager.py import config_backup.json --merge

# 合并模式导入并强制覆盖冲突的提供商
python config_manager.py import config_backup.json --merge --force
```

## 配置文件位置

配置文件存储在用户主目录下的 `.claude_code_config` 文件夹中：

- **Linux/macOS**: `~/.claude_code_config/`
- **Windows**: `C:\Users\<用户名>\.claude_code_config\`

配置文件结构：
- `providers.json`: 存储所有提供商配置
- `current.json`: 存储当前激活的提供商

## 支持的提供商

### 预配置提供商

1. **阿里云通义千问 (qwen)**
   - Base URL: `https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy`
   - 获取API Key: [阿里云百炼平台](https://bailian.console.aliyun.com/)

2. **Kimi (kimi)**
   - Base URL: `https://api.moonshot.cn/anthropic/`
   - 获取API Key: [Kimi开放平台](https://platform.moonshot.cn/)

3. **智谱GLM-4.5 (zhipu)**
   - Base URL: `https://open.bigmodel.cn/api/anthropic`
   - 获取API Key: [智谱AI开放平台](https://open.bigmodel.cn/)

### 自定义提供商

您可以添加任何兼容Anthropic API格式的提供商。

## 环境变量

配置管理器会自动设置以下环境变量：

- `ANTHROPIC_BASE_URL`: API的基础URL
- `ANTHROPIC_AUTH_TOKEN`: API认证令牌

## 故障排除

### 常见问题

**Q: GUI界面无法启动**
```bash
# 安装GUI依赖
pip install PySide6

# 或使用启动脚本自动安装
python start_gui.py
```

**Q: 切换提供商后环境变量未生效**
- 重启终端窗口
- 重新加载shell配置：`source ~/.bashrc` (Linux/macOS)
- 重新登录系统 (Windows)

**Q: 配置文件损坏**
```bash
# 删除配置目录，重新开始
rm -rf ~/.claude_code_config  # Linux/macOS
rmdir /s %USERPROFILE%\.claude_code_config  # Windows
```

**Q: Python命令不存在**
- 确保已安装Python 3.6+
- 尝试使用 `python3` 而不是 `python`

### 调试模式

启用详细日志输出：
```bash
export CLAUDE_CONFIG_DEBUG=1  # Linux/macOS
set CLAUDE_CONFIG_DEBUG=1     # Windows
```

## 高级用法

### 批量操作

```bash
# 批量添加提供商
for provider in provider1 provider2 provider3; do
    python config_manager.py add "$provider" "Provider $provider" "https://api.$provider.com" "key_$provider"
done

# 批量切换测试
for provider in qwen kimi zhipu; do
    echo "Testing $provider..."
    python switch_provider.py "$provider"
    claude --version
done
```

### 脚本集成

在您的脚本中使用配置管理器：

```python
from config_manager import ConfigManager

config = ConfigManager()

# 切换到特定提供商
config.switch_provider('qwen')

# 获取当前配置
current = config.get_current_env_info()
print(f"当前使用: {current['current_provider']}")
```

## 更新和维护

### 更新配置管理器

```bash
# 下载最新版本
curl -O https://raw.githubusercontent.com/sxyseo/kimi-cc/main/config_manager.py
curl -O https://raw.githubusercontent.com/sxyseo/kimi-cc/main/claude_config_gui.py
```

### 备份配置

```bash
# 备份配置目录
cp -r ~/.claude_code_config ~/.claude_code_config.backup
```

### 恢复配置

```bash
# 恢复配置目录
cp -r ~/.claude_code_config.backup ~/.claude_code_config
```

## 贡献和支持

- 项目主页: https://github.com/sxyseo/kimi-cc
- 问题反馈: https://github.com/sxyseo/kimi-cc/issues
- 功能建议: https://github.com/sxyseo/kimi-cc/discussions

## 许可证

本项目采用MIT许可证，详见LICENSE文件。