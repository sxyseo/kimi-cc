# Claude Code 多提供商版本

**中文** | [English](README_EN.md) | [日本語](README_JA.md) | [한국어](README_KO.md) | [Français](README_FR.md) | [Deutsch](README_DE.md) | [Español](README_ES.md) | [Русский](README_RU.md)

使用阿里云通义千问（Qwen）或 Kimi 等多种 AI 模型驱动您的 Claude Code，提供低成本、高性能的 AI 编程助手方案。

## ✨ 特性

- 🚀 **多提供商支持**：支持阿里云通义千问（Qwen）、Kimi 等多种 AI 模型
- 💰 **低成本方案**：使用国产 AI API 替代昂贵的 Anthropic Claude API
- 🔧 **一键安装**：支持 Linux/macOS 和 Windows 的自动化安装脚本
- 🔄 **无缝集成**：完全兼容现有的 Claude Code 工作流程
- 🤖 **最新模型**：
  - **Qwen（推荐）**：阿里云通义千问系列（qwen-plus、qwen-max 等）
  - **Kimi**：月之暗面 kimi-k2-0711-preview 模型
  - **智谱 GLM-4.5**：智谱 AI 最新 GLM-4.5 模型
- 🛡️ **安全可靠**：安全的 API Key 管理和环境变量配置
- 🌐 **灵活配置**：支持自定义 BASE_URL，轻松切换不同提供商

## 📋 系统要求

- Node.js 18.0 或更高版本
- npm 包管理器
- 有效的 API Key（阿里云通义千问 或 Moonshot Kimi）

## 🔧 配置管理器

安装完成后，您将获得强大的**配置管理器**功能，支持：

- 🔄 **快速切换**: 一键切换不同AI提供商
- 🖥️ **图形界面**: 直观的GUI管理界面
- 📱 **命令行工具**: 支持脚本自动化
- 💾 **配置持久化**: 配置自动保存，重启后依然有效

### 🎯 使用配置管理器

**启动图形界面（推荐）:**
```bash
python claude_config_gui.py
# 或自动安装依赖
python start_gui.py
```

**命令行快速切换:**
```bash
python switch_provider.py qwen    # 切换到通义千问
python switch_provider.py kimi    # 切换到Kimi  
python switch_provider.py zhipu   # 切换到智谱GLM-4.5
```

**查看所有提供商:**
```bash
python config_manager.py list
```

详细使用说明请参考：[配置管理器使用指南](CONFIG_MANAGER_README.md)

## 🚀 快速安装

### 📝 获取 API Key

#### 方案一：阿里云通义千问（推荐）

1. 前往阿里云百炼平台申请 API Key

   👉 [阿里云百炼控制台](https://bailian.console.aliyun.com/)

2. 注册/登录阿里云账户，开通百炼服务
3. 导航至：**API-KEY** → **创建我的API-KEY**
4. 复制生成的 API Key（以 `sk-` 开头）

#### 方案二：Kimi（月之暗面）

1. 前往 Kimi 开放平台申请 API Key

   👉 [Kimi开放平台](https://platform.moonshot.cn/)

2. 注册/登录账户，进入用户中心
3. 导航至：**用户中心** → **API Key 管理** → **新建 API Key**
4. 复制生成的 API Key（以 `sk-` 开头）

#### 方案三：智谱 GLM-4.5

1. 前往智谱 AI 开放平台申请 API Key

   👉 [智谱AI开放平台](https://open.bigmodel.cn/)

2. 注册/登录账户，进入控制台
3. 导航至：**控制台** → **API Keys** → **创建 API Key**
4. 复制生成的 API Key（以 `sk-` 开头）

### 💻 Linux / macOS 安装

快速安装，支持选择 API 提供商（Qwen3/Kimi/自定义），会要求您输入相应的 API Key：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

安装过程中您可以选择：
- **选项 1**：Qwen3（阿里云通义千问）- 默认推荐
- **选项 2**：Kimi（月之暗面）
- **选项 3**：智谱 GLM-4.5
- **选项 4**：自定义 BASE_URL

安装完成后会自动配置**配置管理器**，支持多提供商快速切换。
# Claude Code 多提供商版本

**中文** | [English](README_EN.md) | [日本語](README_JA.md) | [한국어](README_KO.md) | [Français](README_FR.md) | [Deutsch](README_DE.md) | [Español](README_ES.md) | [Русский](README_RU.md)

使用阿里云通义千问（Qwen）或 Kimi 等多种 AI 模型驱动您的 Claude Code，提供低成本、高性能的 AI 编程助手方案。

## ✨ 特性

- 🚀 **多提供商支持**：支持阿里云通义千问（Qwen）、Kimi 等多种 AI 模型
- 💰 **低成本方案**：使用国产 AI API 替代昂贵的 Anthropic Claude API
- 🔧 **一键安装**：支持 Linux/macOS 和 Windows 的自动化安装脚本
- 🔄 **无缝集成**：完全兼容现有的 Claude Code 工作流程
- 🤖 **最新模型**：
  - **Qwen（推荐）**：阿里云通义千问系列（qwen-plus、qwen-max 等）
  - **Kimi**：月之暗面 kimi-k2-0711-preview 模型
  - **智谱 GLM-4.5**：智谱 AI 最新 GLM-4.5 模型
- 🛡️ **安全可靠**：安全的 API Key 管理和环境变量配置
- 🌐 **灵活配置**：支持自定义 BASE_URL，轻松切换不同提供商

## 📋 系统要求

- Node.js 18.0 或更高版本
- npm 包管理器
- 有效的 API Key（阿里云通义千问 或 Moonshot Kimi）

## 🚀 快速安装

### 📝 获取 API Key

#### 方案一：阿里云通义千问（推荐）

1. 前往阿里云百炼平台申请 API Key

   👉 [阿里云百炼控制台](https://bailian.console.aliyun.com/)

2. 注册/登录阿里云账户，开通百炼服务
3. 导航至：**API-KEY** → **创建我的API-KEY**
4. 复制生成的 API Key（以 `sk-` 开头）

#### 方案二：Kimi（月之暗面）

1. 前往 Kimi 开放平台申请 API Key

   👉 [Kimi开放平台](https://platform.moonshot.cn/)

2. 注册/登录账户，进入用户中心
3. 导航至：**用户中心** → **API Key 管理** → **新建 API Key**
4. 复制生成的 API Key（以 `sk-` 开头）

#### 方案三：智谱 GLM-4.5

1. 前往智谱 AI 开放平台申请 API Key

   👉 [智谱AI开放平台](https://open.bigmodel.cn/)

2. 注册/登录账户，进入控制台
3. 导航至：**控制台** → **API Keys** → **创建 API Key**
4. 复制生成的 API Key（以 `sk-` 开头）

### 💻 Linux / macOS 安装

快速安装，支持选择 API 提供商（Qwen3/Kimi/自定义），会要求您输入相应的 API Key：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```


### 🪟 Windows 安装

#### 方法一：下载安装脚本（推荐）

1. 下载安装脚本：[install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. 右键选择"以管理员身份运行"
3. 选择 API 提供商（Qwen3/Kimi/智谱GLM-4.5/自定义）
4. 按照提示输入相应的 API Key
5. 等待安装完成

#### 方法二：命令行安装

在PowerShell中运行：

```powershell
# 下载并执行安装脚本
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

或在命令提示符中：

```cmd
# 使用curl下载（Windows 10 1803+）
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ 安装验证

安装完成后，重新打开终端并运行：

```bash
claude --version  # 查看版本信息
claude           # 开始使用Claude Code
```

## 🔧 手动配置

如果自动安装遇到问题，可以手动配置环境变量：

### Linux / macOS

**阿里云通义千问（推荐）：**
```bash
export ANTHROPIC_BASE_URL=https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy
export ANTHROPIC_AUTH_TOKEN=your_qwen_api_key_here
```

**Kimi：**
```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_AUTH_TOKEN=your_kimi_api_key_here
```

**智谱 GLM-4.5：**
```bash
export ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic
export ANTHROPIC_AUTH_TOKEN=your_zhipu_api_key_here
```

### Windows

**阿里云通义千问（推荐）：**

命令提示符 (CMD):
```cmd
set ANTHROPIC_BASE_URL=https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy
set ANTHROPIC_AUTH_TOKEN=your_qwen_api_key_here
```

PowerShell:
```powershell
$env:ANTHROPIC_BASE_URL="https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
$env:ANTHROPIC_AUTH_TOKEN="your_qwen_api_key_here"
```

**Kimi：**

命令提示符 (CMD):
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_AUTH_TOKEN=your_kimi_api_key_here
```

PowerShell:
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_AUTH_TOKEN="your_kimi_api_key_here"
```

**智谱 GLM-4.5：**

命令提示符 (CMD):
```cmd
set ANTHROPIC_BASE_URL=https://open.bigmodel.cn/api/anthropic
set ANTHROPIC_AUTH_TOKEN=your_zhipu_api_key_here
```

PowerShell:
```powershell
$env:ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic"
$env:ANTHROPIC_AUTH_TOKEN="your_zhipu_api_key_here"
```

**永久设置（推荐）:**
1. 右键"此电脑" → 属性 → 高级系统设置 → 环境变量
2. 在用户变量中添加上述两个环境变量

## 🧹 环境清理

如果需要清理 Claude Code 环境变量和配置文件：

### Linux / macOS
```bash
# 下载并运行清理脚本
curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/uninstall.sh | bash
```

### Windows
1. 下载清理脚本：[uninstall_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/uninstall_claude.bat)
2. 右键选择"以管理员身份运行"

清理脚本会安全地移除：
- 环境变量：`ANTHROPIC_BASE_URL` 和 `ANTHROPIC_API_KEY`
- 配置文件：`.claude.json`
- 并创建备份文件以防意外

## 🎯 使用方法

安装完成后，您可以像使用原版Claude Code一样使用：

```bash
claude  # 启动交互式对话
```

## 🔍 故障排除

### 常见问题

**Q: 提示"claude 不是内部或外部命令"**
- 重新打开终端窗口
- 检查Node.js和npm是否正确安装
- 重新安装：`npm install -g @anthropic-ai/claude-code`

**Q: 提示"Invalid API key"**
- 检查API Key是否正确设置
- 确认API Key以`sk-`开头
- 重新运行安装脚本

**Q: Windows环境变量不生效**
- 重启命令行窗口
- 重新登录系统
- 使用管理员权限运行安装脚本

### 环境变量测试

**检查环境变量是否正确设置：**

Linux/macOS:
```bash
echo $ANTHROPIC_BASE_URL
echo $ANTHROPIC_AUTH_TOKEN
```

Windows CMD:
```cmd
echo %ANTHROPIC_BASE_URL%
echo %ANTHROPIC_AUTH_TOKEN%
```

Windows PowerShell:
```powershell
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_AUTH_TOKEN
```

## 🤝 贡献

欢迎提交Issues和Pull Requests来改进这个项目！

1. Fork 这个仓库
2. 创建您的功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建一个Pull Request

## 📄 许可证

本项目采用MIT许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🔗 相关链接

- 🌐 [阿里云百炼平台](https://bailian.console.aliyun.com/)
- 🌙 [Kimi开放平台](https://platform.moonshot.cn/)
- 🧠 [智谱AI开放平台](https://open.bigmodel.cn/)
- 📖 [Claude Code官方文档](https://docs.anthropic.com/claude/docs)
- 📚 [通义千问API文档](https://help.aliyun.com/zh/model-studio/use-qwen-by-calling-api)
- 📋 [智谱AI API文档](https://docs.bigmodel.cn/cn/guide/develop/claude)
- 🐛 [问题反馈](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [讨论交流](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ 支持

如果这个项目对您有帮助，请给我们一个⭐️！

---

**免责声明**: 本项目仅供学习和研究使用，请遵守相关API的使用条款。
