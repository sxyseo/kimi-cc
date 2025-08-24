#!/bin/bash

set -e

install_nodejs() {
    local platform=$(uname -s)

    case "$platform" in
        Linux|Darwin)
            echo "🚀 Installing Node.js on Unix/Linux/macOS..."

            echo "📥 Downloading and installing nvm..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

            echo "🔄 Loading nvm environment..."
            \. "$HOME/.nvm/nvm.sh"

            echo "📦 Downloading and installing Node.js v22..."
            nvm install 22

            echo -n "✅ Node.js installation completed! Version: "
            node -v # Should print "v22.17.0".
            echo -n "✅ Current nvm version: "
            nvm current # Should print "v22.17.0".
            echo -n "✅ npm version: "
            npm -v # Should print "10.9.2".
            ;;
        *)
            echo "Unsupported platform: $platform"
            exit 1
            ;;
    esac
}

echo "[Step 1/5] 检查 Node.js 安装状态..."

# Check if Node.js is already installed and version is >= 18
if command -v node >/dev/null 2>&1; then
    current_version=$(node -v | sed 's/v//')
    major_version=$(echo $current_version | cut -d. -f1)

    if [ "$major_version" -ge 18 ]; then
        echo "[成功] 检测到 Node.js v$current_version (满足要求)"
        echo "[信息] npm 版本: $(npm -v)"
    else
        echo "[警告] Node.js v$current_version 版本过低，需要 v18 或更高版本。正在升级..."
        install_nodejs
    fi
else
    echo "[信息] 未找到 Node.js，正在安装..."
    install_nodejs
fi

echo ""
echo "[Step 2/5] 检查 Claude Code 安装状态..."

# Check if Claude Code is already installed
if command -v claude >/dev/null 2>&1; then
    echo "[信息] Claude Code 已安装"
    claude_version=$(claude --version 2>/dev/null || echo "版本信息获取失败")
    echo "[信息] 当前版本: $claude_version"
else
    echo "[信息] Claude Code 未安装，正在安装..."
    npm install -g @anthropic-ai/claude-code
    if [ $? -eq 0 ]; then
        echo "[成功] Claude Code 安装完成"
    else
        echo "[错误] Claude Code 安装失败"
        exit 1
    fi
fi

echo ""
echo "[Step 3/5] 配置 Claude Code 跳过引导..."

# Configure Claude Code to skip onboarding
node --eval '
    const os = require("os");
    const fs = require("fs");
    const path = require("path");
    const homeDir = os.homedir();
    const filePath = path.join(homeDir, ".claude.json");
    try {
        if (fs.existsSync(filePath)) {
            const content = JSON.parse(fs.readFileSync(filePath, "utf-8"));
            fs.writeFileSync(filePath, JSON.stringify({ ...content, hasCompletedOnboarding: true }, null, 2), "utf-8");
            console.log("[成功] 已更新现有配置文件");
        } else {
            fs.writeFileSync(filePath, JSON.stringify({ hasCompletedOnboarding: true }, null, 2), "utf-8");
            console.log("[成功] 已创建新配置文件");
        }
    } catch (error) {
        console.log("[警告] 配置文件设置可能失败，但不影响后续使用");
    }
' 2>/dev/null || echo "[警告] 配置文件设置可能失败，但不影响后续使用"

echo ""
echo "[Step 4/5] 配置 API 提供商..."
echo ""
echo "🌐 请选择 API 提供商:"
echo "   1. Qwen3 (阿里云通义千问) - 默认推荐"
echo "   2. Kimi (月之暗面)"
echo "   3. 智谱 GLM-4.5"
echo "   4. 自定义 BASE_URL"
echo ""
read -p "请选择选项 (1, 2, 3 或 4, 默认: 1): " base_url_choice
echo ""

case "$base_url_choice" in
    2)
        base_url="https://api.moonshot.cn/anthropic/"
        echo "✅ Using Kimi BASE_URL: $base_url"
        ;;
    3)
        base_url="https://open.bigmodel.cn/api/anthropic"
        echo "✅ Using Zhipu AI GLM-4.5 BASE_URL: $base_url"
        ;;
    4)
        echo "🔗 Please enter your custom BASE_URL:"
        read base_url
        if [ -z "$base_url" ]; then
            echo "⚠️  BASE_URL cannot be empty. Using default Qwen3 BASE_URL."
            base_url="https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
        fi
        echo "✅ Using custom BASE_URL: $base_url"
        ;;
    *)
        base_url="https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
        echo "✅ Using default Qwen3 BASE_URL: $base_url"
        ;;
esac

# Prompt user for API key based on selected BASE_URL
echo ""
if echo "$base_url" | grep -q "moonshot"; then
    echo "🔑 Please enter your Kimi API key:"
    echo "   You can get your API key from: https://platform.moonshot.cn/console/api-keys"
    api_provider="Kimi"
elif echo "$base_url" | grep -q "bigmodel"; then
    echo "🔑 Please enter your Zhipu AI API key:"
    echo "   You can get your API key from: https://open.bigmodel.cn/console/apikeys"
    api_provider="Zhipu AI"
elif echo "$base_url" | grep -q "dashscope"; then
    echo "🔑 Please enter your Qwen3 API key:"
    echo "   You can get your API key from: https://dashscope.console.aliyun.com/apiKey"
    api_provider="Qwen3"
else
    echo "🔑 Please enter your API key:"
    echo "   Please refer to your API provider's documentation for obtaining the API key"
    api_provider="Custom"
fi
echo "   Note: The input is hidden for security. Please paste your API key directly."
echo ""
stty -echo
read api_key
stty echo
echo ""

if [ -z "$api_key" ]; then
    echo "⚠️  API key cannot be empty. Please run the script again."
    exit 1
fi

# Detect current shell and determine rc file
current_shell=$(basename "$SHELL")
case "$current_shell" in
    bash)
        rc_file="$HOME/.bashrc"
        ;;
    zsh)
        rc_file="$HOME/.zshrc"
        ;;
    fish)
        rc_file="$HOME/.config/fish/config.fish"
        ;;
    *)
        rc_file="$HOME/.profile"
        ;;
esac

echo ""
echo "[Step 5/5] 设置环境变量..."

# Add environment variables to rc file
echo "📝 正在添加环境变量到 $rc_file..."

# Check if variables already exist to avoid duplicates
if [ -f "$rc_file" ] && grep -q "ANTHROPIC_BASE_URL\|ANTHROPIC_AUTH_TOKEN" "$rc_file"; then
    echo "[警告] 环境变量已存在于 $rc_file 中，跳过设置..."
else
    # Append new entries
    echo "" >> "$rc_file"
    echo "# Claude Code environment variables for $api_provider" >> "$rc_file"
    echo "export ANTHROPIC_BASE_URL=$base_url" >> "$rc_file"
    echo "export ANTHROPIC_AUTH_TOKEN=$api_key" >> "$rc_file"
    echo "[成功] 环境变量已添加到 $rc_file"
fi

# 保存配置到配置管理器
echo ""
echo "[配置管理] 保存提供商配置..."

# 检查是否有Python
if command -v python3 >/dev/null 2>&1; then
    python_cmd="python3"
elif command -v python >/dev/null 2>&1; then
    python_cmd="python"
else
    echo "[警告] 未找到Python，跳过配置管理功能"
    python_cmd=""
fi

if [ -n "$python_cmd" ]; then
    # 下载配置管理器（如果不存在）
    if [ ! -f "config_manager.py" ]; then
        echo "正在下载配置管理器..."
        curl -fsSL https://raw.githubusercontent.com/sxyseo/kimi-cc/main/config_manager.py -o config_manager.py 2>/dev/null || echo "[警告] 下载配置管理器失败"
    fi
    
    if [ -f "config_manager.py" ]; then
        # 根据选择的提供商设置ID
        case "$base_url_choice" in
            2) provider_id="kimi" ;;
            3) provider_id="zhipu" ;;
            *) provider_id="qwen" ;;
        esac
        
        # 更新配置
        $python_cmd config_manager.py update "$provider_id" --api_key "$api_key" 2>/dev/null || echo "[警告] 更新配置失败"
        $python_cmd config_manager.py switch "$provider_id" 2>/dev/null || echo "[警告] 切换配置失败"
        
        echo "[成功] 配置已保存到配置管理器"
    fi
fi

echo ""
echo "================================================================"
echo "                    🎉 安装完成！"
echo "================================================================"
echo ""
echo "安装摘要:"
echo "  ✅ Node.js: 已安装并配置"
echo "  ✅ Claude Code: 已安装并配置"
echo "  ✅ API 提供商: $api_provider"
echo "  ✅ 环境变量: 已设置"
echo "  ✅ 配置管理: 已启用"
echo ""
echo "使用说明:"
echo ""
echo "🔄 请重启终端或运行以下命令:"
echo "   source $rc_file"
echo ""
echo "🚀 然后您可以开始使用 Claude Code:"
echo "   claude"
echo ""
echo "🔧 配置管理功能:"
if [ -n "$python_cmd" ] && [ -f "config_manager.py" ]; then
    echo "   • 查看所有提供商: $python_cmd config_manager.py list"
    echo "   • 快速切换提供商: $python_cmd switch_provider.py <provider_id>"
    echo "   • 启动GUI管理器: $python_cmd claude_config_gui.py"
    echo ""
    echo "   安装GUI依赖: pip install PySide6"
fi
echo ""
echo "📚 相关链接:"
if [[ "$api_provider" == "Kimi" ]]; then
    echo "   • Kimi 开放平台: https://platform.moonshot.cn/"
elif [[ "$api_provider" == "Zhipu AI" ]]; then
    echo "   • 智谱AI 开放平台: https://open.bigmodel.cn/"
elif [[ "$api_provider" == "Qwen3" ]]; then
    echo "   • 阿里云百炼平台: https://bailian.console.aliyun.com/"
fi
echo "   • 项目主页: https://github.com/sxyseo/kimi-cc"
echo ""
echo "如有问题，请访问项目主页获取支持。"
echo "================================================================"
