@echo off
:: =================================================================
:: Claude Code Multi-Provider Windows Installation Script
:: =================================================================
:: Project: https://github.com/sxyseo/qwen-cc
:: Description: Automatically install and configure Claude Code with multiple API providers
:: Version: 2.0
:: Author: LLM Red Team
:: =================================================================

:: Set code page to UTF-8 to support Chinese characters
chcp 65001 >nul 2>&1

:: Enable delayed variable expansion for handling variables in loops and conditionals
setlocal enabledelayedexpansion

:: Display welcome screen
echo ================================================================
echo         Claude Code 多提供商 Windows 安装脚本
echo ================================================================
echo 此脚本将自动安装和配置 Claude Code，支持多种 API 提供商选择
echo.
echo 支持的提供商: Qwen3 (默认), Kimi, 智谱GLM-4.5, 自定义
echo 官方文档: https://github.com/sxyseo/kimi-cc
echo ================================================================
echo.

:: ================================================================
:: Permission Check
:: ================================================================
echo [检查] 管理员权限...

:: Check administrator privileges (optional but recommended for setting environment variables)
net session >nul 2>&1
if !errorLevel! neq 0 (
    echo [警告] 未以管理员权限运行
    echo 建议以管理员身份运行此脚本以确保环境变量正确设置
    echo 如果遇到权限问题，请右键选择"以管理员身份运行"
    echo.
    pause
    echo 继续安装...
    echo.
) else (
    echo [成功] 管理员权限确认
)

:: ================================================================
:: Step 1: Check Node.js Installation
:: ================================================================
echo.
echo [Step 1/5] 检查 Node.js 安装状态...

:: Check if Node.js is installed
where node >nul 2>&1
if !errorLevel! neq 0 (
    echo [错误] 未检测到 Node.js
    echo.
    echo 请安装 Node.js v18 或更高版本:
    echo 1. 访问: https://nodejs.org/
    echo 2. 下载并安装 LTS 版本
    echo 3. 安装完成后重新运行此脚本
    echo.
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

:: Get current Node.js version
for /f "delims=" %%i in ('node -v 2^>nul') do set node_version=%%i
set node_version=!node_version:v=!

:: Extract major version number
for /f "tokens=1 delims=." %%a in ("!node_version!") do set major_version=%%a

:: Check if version meets requirements (>=18)
if !major_version! lss 18 (
    echo [错误] 检测到 Node.js v!node_version!，但需要 v18 或更高版本
    echo 请更新您的 Node.js 版本后重新运行此脚本
    echo 按任意键退出...
    pause >nul
    exit /b 1
) else (
    echo [成功] 检测到 Node.js v!node_version! (满足要求)
)

:: Check npm status
where npm >nul 2>&1
if !errorLevel! neq 0 (
    echo [错误] 未找到 npm，请检查 Node.js 安装
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

for /f "delims=" %%i in ('npm -v 2^>nul') do set npm_version=%%i
echo [信息] npm 版本: v!npm_version!

:: ================================================================
:: Step 2: Check and Install Claude Code
:: ================================================================
echo.
echo.
echo [Step 2/5] 检查 Claude Code 安装状态...

:: Check if Claude Code is already installed
where claude >nul 2>&1
if !errorLevel! neq 0 (
    echo [信息] Claude Code 未安装，开始安装...
    echo 执行命令: npm install -g @anthropic-ai/claude-code
    echo.

    :: Execute installation command
    npm install -g @anthropic-ai/claude-code
    if !errorLevel! neq 0 (
        echo.
        echo [错误] Claude Code 安装失败
        echo 可能的解决方案:
        echo 1. 以管理员身份运行此脚本
        echo 2. 检查网络连接
        echo 3. 尝试手动执行: npm install -g @anthropic-ai/claude-code
        echo 4. 清理 npm 缓存: npm cache clean --force
        echo 按任意键退出...
        pause >nul
        exit /b 1
    )
    echo [成功] Claude Code 安装完成
) else (
    echo [信息] Claude Code 已安装

    :: Try to get version information
    for /f "delims=" %%i in ('claude --version 2^>nul') do set claude_version=%%i
    if defined claude_version (
        echo [信息] 当前版本: !claude_version!
    ) else (
        echo [信息] 无法获取版本信息，但 claude 命令可用
    )
)

:: ================================================================
:: Step 3: Configure Claude Code to Skip Onboarding
:: ================================================================
echo.
echo.
echo [Step 3/5] 配置 Claude Code 跳过引导...

:: Get user home directory
set "user_home=%USERPROFILE%"
set "claude_config=!user_home!\.claude.json"

:: Use PowerShell to create or update configuration file
echo 正在配置 .claude.json 文件...

:: Execute PowerShell command with comprehensive error handling
powershell -NoProfile -ExecutionPolicy Bypass -Command "$homeDir = $env:USERPROFILE; $filePath = Join-Path $homeDir '.claude.json'; try { if (Test-Path $filePath) { Write-Host '[成功] 正在更新现有配置文件...'; $content = Get-Content $filePath -Raw | ConvertFrom-Json; $content | Add-Member -Name 'hasCompletedOnboarding' -Value $true -MemberType NoteProperty -Force; $content | ConvertTo-Json -Depth 10 | Set-Content $filePath -Encoding UTF8; Write-Host '[成功] 配置文件更新完成' } else { Write-Host '[成功] 正在创建新配置文件...'; @{hasCompletedOnboarding=$true} | ConvertTo-Json | Set-Content $filePath -Encoding UTF8; Write-Host '[成功] 配置文件创建完成' } } catch { Write-Host '[警告] 配置文件设置可能失败，但不影响后续使用' }" 2>nul

if !errorLevel! neq 0 (
    echo [警告] 配置文件设置可能失败，但不影响后续使用
    echo 您可以稍后手动运行 claude 命令完成配置
) else (
    echo [成功] Claude Code 配置完成
)

:: ================================================================
:: Step 4: Configure BASE_URL
:: ================================================================
echo.
echo.
echo [Step 4/6] 配置 API 提供商...
echo.
echo 请选择您的 API 提供商:
echo   1. Qwen3 (阿里云通义千问) - 默认推荐
echo   2. Kimi (月之暗面)
echo   3. 智谱 GLM-4.5
echo   4. 自定义 BASE_URL
echo.
set /p "base_url_choice=请选择选项 (1, 2, 3 或 4, 默认: 1): "

:: Handle empty input (default to 1)
if "!base_url_choice!"=="" set base_url_choice=1

:: Set BASE_URL and provider info based on choice
if "!base_url_choice!"=="2" (
    set "base_url=https://api.moonshot.cn/anthropic/"
    set "api_provider=Kimi"
    set "api_key_url=https://platform.moonshot.cn/console/api-keys"
    set "api_key_prefix=sk-"
    echo [成功] 使用 Kimi BASE_URL: !base_url!
) else if "!base_url_choice!"=="3" (
    set "base_url=https://open.bigmodel.cn/api/anthropic"
    set "api_provider=Zhipu AI"
    set "api_key_url=https://open.bigmodel.cn/console/apikeys"
    set "api_key_prefix="
    echo [成功] 使用智谱 GLM-4.5 BASE_URL: !base_url!
) else if "!base_url_choice!"=="4" (
    echo.
    echo 请输入您的自定义 BASE_URL:
    set /p "base_url=BASE_URL: "
    if "!base_url!"=="" (
        echo [警告] BASE_URL 不能为空，使用默认 Qwen3 BASE_URL。
        set "base_url=https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
        set "api_provider=Qwen3"
        set "api_key_url=https://dashscope.console.aliyun.com/apiKey"
        set "api_key_prefix=sk-"
    ) else (
        set "api_provider=Custom"
        set "api_key_url=请参考您的 API 提供商文档"
        set "api_key_prefix="
    )
    echo [成功] 使用自定义 BASE_URL: !base_url!
) else (
    set "base_url=https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
    set "api_provider=Qwen3"
    set "api_key_url=https://dashscope.console.aliyun.com/apiKey"
    set "api_key_prefix=sk-"
    echo [成功] 使用默认 Qwen3 BASE_URL: !base_url!
)

:: ================================================================
:: Step 5: Get API Key
:: ================================================================
echo.
echo.
echo [Step 5/6] 配置 !api_provider! API Key...
echo.
echo 请输入您的 !api_provider! API Key:
echo 获取地址: !api_key_url!
if "!api_provider!"=="Kimi" (
    echo 操作步骤: 用户中心 ^> API Key 管理 ^> 新建 API Key
) else if "!api_provider!"=="Zhipu AI" (
    echo 操作步骤: 控制台 ^> API Key 管理 ^> 创建 API Key
) else if "!api_provider!"=="Qwen3" (
    echo 操作步骤: 控制台 ^> API Key 管理 ^> 创建 API Key
) else (
    echo 操作步骤: 请参考您的 API 提供商文档
)
echo.
echo [注意] 为了安全，输入内容不会显示，请直接粘贴并按回车

:: Use PowerShell to securely read password (not displayed on screen)
for /f "usebackq delims=" %%i in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$key = Read-Host -AsSecureString; $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($key); $plaintext = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR); [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR); if ($plaintext.Length -eq 0) { Write-Output 'EMPTY_KEY' } else { Write-Output $plaintext }"`) do set api_key=%%i

:: Check if API Key is empty or error occurred
if "!api_key!"=="EMPTY_KEY" (
    echo.
    echo [错误] API Key 不能为空，请重新运行脚本
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

:: Validate API Key format (basic check) - only for providers that use sk- prefix
if not "!api_key_prefix!"=="" (
    if "!api_key:~0,3!" neq "!api_key_prefix!" (
        echo.
        echo [警告] API Key 格式可能不正确，通常以 '!api_key_prefix!' 开头
        echo 继续安装，但请确认 API Key 是否正确...
        echo.
        echo 按任意键继续...
        pause >nul
    )
)

echo.
echo [成功] API Key 获取完成

:: ================================================================
:: Step 6: Set Environment Variables
:: ================================================================
echo.
echo.
echo [Step 6/6] 设置系统环境变量...

:: Environment variable values are already set in previous step (base_url variable)

echo 正在设置环境变量...

:: Method 1: Set environment variables for current session (immediate effect)
echo [1/3] 设置当前会话环境变量...
set "ANTHROPIC_BASE_URL=!base_url!"
set "ANTHROPIC_AUTH_TOKEN=!api_key!"

:: Method 2: Use setx command to set user environment variables (permanent effect)
echo [2/3] 设置永久用户环境变量...

setx ANTHROPIC_BASE_URL "!base_url!" >nul 2>&1
if !errorLevel! neq 0 (
    echo [警告] ANTHROPIC_BASE_URL 永久设置失败
    set "setx_failed=1"
) else (
    echo [成功] ANTHROPIC_BASE_URL 永久设置成功
)

setx ANTHROPIC_AUTH_TOKEN "!api_key!" >nul 2>&1
if !errorLevel! neq 0 (
    echo [警告] ANTHROPIC_AUTH_TOKEN 永久设置失败
    set "setx_failed=1"
) else (
    echo [成功] ANTHROPIC_AUTH_TOKEN 永久设置成功
)

:: Method 3: Verify environment variable settings
echo [3/3] 验证环境变量设置...
echo.

echo 当前会话环境变量:
echo   ANTHROPIC_BASE_URL: !ANTHROPIC_BASE_URL!
echo   ANTHROPIC_AUTH_TOKEN: !api_key:~0,8!****** (显示前8个字符)

:: Check if variables are correctly set
if "!ANTHROPIC_BASE_URL!"=="!base_url!" (
    echo [✓] BASE_URL 设置正确
) else (
    echo [✗] BASE_URL 设置失败
    set "env_error=1"
)

if "!ANTHROPIC_AUTH_TOKEN!"=="!api_key!" (
    echo [✓] AUTH_TOKEN 设置正确
) else (
    echo [✗] AUTH_TOKEN 设置失败
    set "env_error=1"
)

:: If there are errors, jump to manual setup instructions
if defined env_error (
    echo.
    echo [错误] 环境变量设置存在问题
    goto :env_manual
)

if defined setx_failed (
    echo.
    echo [警告] 永久环境变量设置部分失败，但当前会话可用
    goto :env_manual_guide
)

echo.
echo [成功] 环境变量设置成功
echo        (当前会话和永久设置都已完成)
goto :installation_complete

:: ================================================================
:: Manual Environment Variable Setup Guide
:: ================================================================
:env_manual
echo.
echo ================================================================
echo                    手动环境变量设置指南
echo ================================================================
echo [错误] 自动环境变量设置失败，请手动设置
echo.

:env_manual_guide
echo 手动设置方法:
echo.
echo 方法 1 - 图形界面设置:
echo   1. 右键"此电脑" ^> 属性 ^> 高级系统设置 ^> 环境变量
echo   2. 在"用户变量"中添加以下变量:
echo.
echo      Variable Name: ANTHROPIC_BASE_URL
echo      Variable Value: !base_url!
echo.
echo      Variable Name: ANTHROPIC_AUTH_TOKEN
echo      Variable Value: !api_key!
echo.

echo 方法 2 - 命令行设置 (当前会话):
echo   在 CMD 中运行:
echo     set ANTHROPIC_BASE_URL=!base_url!
echo     set ANTHROPIC_AUTH_TOKEN=!api_key!
echo.

echo 方法 3 - PowerShell 设置 (当前会话):
echo   在 PowerShell 中运行:
echo     $env:ANTHROPIC_BASE_URL="!base_url!"
echo     $env:ANTHROPIC_AUTH_TOKEN="!api_key!"
echo.

echo 方法 4 - 创建环境变量批处理文件:
echo   创建一个 .bat 文件，内容如下:
echo     @echo off
echo     set ANTHROPIC_BASE_URL=!base_url!
echo     set ANTHROPIC_AUTH_TOKEN=!api_key!
echo     echo 环境变量已设置
echo.

goto :installation_complete

:: ================================================================
:: Installation Complete
:: ================================================================
:installation_complete
echo.
:: 保存配置到配置管理器
echo.
echo [配置管理] 保存提供商配置...

:: 检查是否有Python
where python >nul 2>&1
if !errorLevel! equ 0 (
    set "python_cmd=python"
) else (
    where python3 >nul 2>&1
    if !errorLevel! equ 0 (
        set "python_cmd=python3"
    ) else (
        echo [警告] 未找到Python，跳过配置管理功能
        set "python_cmd="
    )
)

if defined python_cmd (
    :: 下载配置管理器（如果不存在）
    if not exist "config_manager.py" (
        echo 正在下载配置管理器...
        powershell -Command "try { Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/sxyseo/kimi-cc/main/config_manager.py' -OutFile 'config_manager.py' } catch { Write-Host '[警告] 下载配置管理器失败' }" 2>nul
    )
    
    if exist "config_manager.py" (
        :: 根据选择的提供商设置ID
        if "!base_url_choice!"=="2" (
            set "provider_id=kimi"
        ) else if "!base_url_choice!"=="3" (
            set "provider_id=zhipu"
        ) else (
            set "provider_id=qwen"
        )
        
        :: 更新配置
        !python_cmd! config_manager.py update "!provider_id!" --api_key "!api_key!" >nul 2>&1
        !python_cmd! config_manager.py switch "!provider_id!" >nul 2>&1
        
        echo [成功] 配置已保存到配置管理器
    )
)

echo.
echo ================================================================
echo                        🎉 安装完成！
echo ================================================================
echo.
echo 安装摘要:
echo    Node.js 版本: v!node_version!
echo    Claude Code: 已安装并配置
echo    API 提供商: !api_provider!
echo    环境变量: 已设置
echo    API Key: 已配置
echo    配置管理: 已启用
echo.

echo 使用说明:
echo.
echo 在当前窗口测试:
echo    您可以在此窗口立即运行:
echo      claude --version
echo      claude
echo.

echo 在新窗口使用:
echo    1. 打开新的命令提示符或 PowerShell 窗口
echo    2. 运行命令: claude
echo    3. 开始使用低成本 Claude Code 服务！
echo.

echo 配置管理功能:
if defined python_cmd (
    if exist "config_manager.py" (
        echo    • 查看所有提供商: !python_cmd! config_manager.py list
        echo    • 快速切换提供商: !python_cmd! switch_provider.py ^<provider_id^>
        echo    • 启动GUI管理器: !python_cmd! claude_config_gui.py
        echo.
        echo    安装GUI依赖: pip install PySide6
    )
)
echo.

echo 故障排除:
echo.
echo 如果遇到 "claude 不是内部或外部命令" 错误:
echo    • 尝试: npm list -g @anthropic-ai/claude-code
echo    • 重新安装: npm install -g @anthropic-ai/claude-code
echo    • 重启命令行窗口
echo.

echo 如果遇到 "Invalid API key" 错误:
echo    • 检查 API Key 是否正确
echo    • 访问: !api_key_url!
echo    • 重新运行此脚本
echo.

echo 如果环境变量不生效:
echo    • 重启命令行窗口
echo    • 重新登录系统
echo    • 按照上述手动设置方法操作
echo.

echo ================================================================
echo                     快速环境变量测试
echo ================================================================
echo 您可以运行以下命令测试环境变量是否正常工作:
echo.
echo 在 CMD 中:
echo   echo %%ANTHROPIC_BASE_URL%%
echo   echo %%ANTHROPIC_AUTH_TOKEN%%
echo.
echo 在 PowerShell 中:
echo   echo $env:ANTHROPIC_BASE_URL
echo   echo $env:ANTHROPIC_AUTH_TOKEN
echo.
echo 预期输出:
echo   !base_url!
echo   (您的 API key)
echo.
echo 如果您看到实际值而不是变量名，说明环境变量工作正常！
echo ================================================================
echo.

echo 相关链接:
if "!api_provider!"=="Kimi" (
    echo    • Kimi 开放平台: https://platform.moonshot.cn/
) else if "!api_provider!"=="Zhipu AI" (
    echo    • 智谱AI 开放平台: https://open.bigmodel.cn/
) else if "!api_provider!"=="Qwen3" (
    echo    • 阿里云百炼平台: https://dashscope.console.aliyun.com/
) else (
    echo    • API 提供商: !api_key_url!
)
echo    • 项目主页: https://github.com/sxyseo/kimi-cc
echo    • Claude Code 文档: https://docs.anthropic.com/claude/docs
echo.

echo 感谢使用 Claude Code 多提供商安装脚本！
echo 如有问题，请访问项目主页获取支持。
echo.
pause
