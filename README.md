# Kimi CC

**中文** | [English](README_EN.md) | [日本語](README_JA.md) | [한국어](README_KO.md) | [Français](README_FR.md) | [Deutsch](README_DE.md) | [Español](README_ES.md) | [Русский](README_RU.md)

使用Kimi的最新模型（kimi-k2-0711-preview）驱动您的Claude Code，提供低成本的AI编程助手方案。

## ✨ 特性

- 🚀 **低成本方案**：使用Kimi API替代昂贵的Anthropic Claude API
- 🔧 **一键安装**：支持Linux/macOS和Windows的自动化安装脚本
- 🔄 **无缝集成**：完全兼容现有的Claude Code工作流程
- 🤖 **最新模型**：基于Kimi的kimi-k2-0711-preview模型
- 🛡️ **安全可靠**：安全的API Key管理和环境变量配置

## 📋 系统要求

- Node.js 18.0 或更高版本
- npm 包管理器
- 有效的Moonshot API Key

## 🚀 快速安装

### 📝 获取 API Key

1. 前往Kimi开放平台申请API Key

   👉 [Kimi开放平台](https://platform.moonshot.cn/)

2. 注册/登录账户，进入用户中心
3. 导航至：**用户中心** → **API Key 管理** → **新建 API Key**
4. 复制生成的API Key（以`sk-`开头）

### 💻 Linux / macOS 安装

快速安装，会要求您输入 API Key，最终回车即可：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Windows 安装

#### 方法一：下载安装脚本（推荐）

1. 下载安装脚本：[install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. 右键选择"以管理员身份运行"
3. 按照提示输入您的Moonshot API Key
4. 等待安装完成

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

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**命令提示符 (CMD):**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell:**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**永久设置（推荐）:**
1. 右键"此电脑" → 属性 → 高级系统设置 → 环境变量
2. 在用户变量中添加上述两个环境变量

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
echo $ANTHROPIC_API_KEY
```

Windows CMD:
```cmd
echo %ANTHROPIC_BASE_URL%
echo %ANTHROPIC_API_KEY%
```

Windows PowerShell:
```powershell
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_API_KEY
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

- 🌐 [Kimi开放平台](https://platform.moonshot.cn/)
- 📖 [Claude Code官方文档](https://docs.anthropic.com/claude/docs)
- 🐛 [问题反馈](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [讨论交流](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ 支持

如果这个项目对您有帮助，请给我们一个⭐️！

---

**免责声明**: 本项目仅供学习和研究使用，请遵守相关API的使用条款。
