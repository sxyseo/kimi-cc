# Kimi CC

[中文](README.md) | **English** | [日本語](README_JA.md) | [한국어](README_KO.md) | [Français](README_FR.md) | [Deutsch](README_DE.md) | [Español](README_ES.md) | [Русский](README_RU.md)

Use Kimi's latest model (kimi-k2-0711-preview) to power your Claude Code, providing a low-cost AI programming assistant solution.

## ✨ Features

- 🚀 **Cost-effective**: Use Kimi API instead of expensive Anthropic Claude API
- 🔧 **One-click installation**: Automated installation scripts for Linux/macOS and Windows
- 🔄 **Seamless integration**: Fully compatible with existing Claude Code workflows
- 🤖 **Latest model**: Powered by Kimi's kimi-k2-0711-preview model
- 🛡️ **Secure and reliable**: Secure API key management and environment variable configuration

## 📋 System Requirements

- Node.js 18.0 or higher
- npm package manager
- Valid Moonshot API Key

## 🚀 Quick Installation

### 📝 Get API Key

1. Go to Kimi Open Platform to apply for an API Key

   👉 [Kimi Open Platform](https://platform.moonshot.cn/)

2. Register/login to your account and enter User Center
3. Navigate to: **User Center** → **API Key Management** → **Create New API Key**
4. Copy the generated API Key (starts with `sk-`)

### 💻 Linux / macOS Installation

Quick installation - you will be prompted to enter your API Key, then press Enter to complete:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install.sh)"
```

### 🪟 Windows Installation

#### Method 1: Download Installation Script (Recommended)

1. Download the installation script: [install_claude.bat](https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat)
2. Right-click and select "Run as administrator"
3. Follow the prompts to enter your Moonshot API Key
4. Wait for installation to complete

#### Method 2: Command Line Installation

In PowerShell:

```powershell
# Download and execute installation script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat" -OutFile "install_claude.bat"
.\install_claude.bat
```

Or in Command Prompt:

```cmd
# Use curl to download (Windows 10 1803+)
curl -L -o install_claude.bat https://raw.githubusercontent.com/sxyseo/kimi-cc/refs/heads/main/install_claude.bat
install_claude.bat
```

### ✅ Installation Verification

After installation, restart your terminal and run:

```bash
claude --version  # Check version information
claude           # Start using Claude Code
```

## 🔧 Manual Configuration

If automatic installation encounters issues, you can manually configure environment variables:

### Linux / macOS

```bash
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
export ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

### Windows

**Command Prompt (CMD):**
```cmd
set ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic/
set ANTHROPIC_API_KEY=your_moonshot_api_key_here
```

**PowerShell:**
```powershell
$env:ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic/"
$env:ANTHROPIC_API_KEY="your_moonshot_api_key_here"
```

**Permanent Setup (Recommended):**
1. Right-click "This PC" → Properties → Advanced System Settings → Environment Variables
2. Add the above two environment variables in "User Variables"

## 🎯 Usage

After installation, you can use it just like the original Claude Code:

```bash
claude  # Start interactive conversation
```

## 🔍 Troubleshooting

### Common Issues

**Q: "claude is not recognized as an internal or external command"**
- Restart terminal window
- Check if Node.js and npm are properly installed
- Reinstall: `npm install -g @anthropic-ai/claude-code`

**Q: "Invalid API key" error**
- Check if API Key is correctly set
- Ensure API Key starts with `sk-`
- Re-run the installation script

**Q: Windows environment variables not working**
- Restart command line window
- Re-login to system
- Run installation script with administrator privileges

### Environment Variable Testing

**Check if environment variables are correctly set:**

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

## 🤝 Contributing

We welcome Issues and Pull Requests to improve this project!

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Links

- 🌐 [Kimi Open Platform](https://platform.moonshot.cn/)
- 📖 [Claude Code Official Documentation](https://docs.anthropic.com/claude/docs)
- 🐛 [Issue Reporting](https://github.com/sxyseo/kimi-cc/issues)
- 💬 [Discussions](https://github.com/sxyseo/kimi-cc/discussions)

## ⭐ Support

If this project helps you, please give us a ⭐️!

---

**Disclaimer**: This project is for learning and research purposes only. Please comply with the terms of use of the relevant APIs. 