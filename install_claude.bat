@echo off
:: =================================================================
:: Kimi CC Windows 安装脚本 / Kimi CC Windows Installation Script
:: =================================================================
:: 项目地址 / Project: https://github.com/sxyseo/kimi-cc
:: 说明 / Description: 自动安装和配置 Claude Code 使用 Kimi API
::                    Automatically install and configure Claude Code to use Kimi API
:: 版本 / Version: 1.2
:: 作者 / Author: LLM Red Team
:: =================================================================

:: 启用延迟变量展开，用于处理循环和条件语句中的变量
:: Enable delayed variable expansion for handling variables in loops and conditionals
setlocal enabledelayedexpansion

:: 设置UTF-8编码以支持中文显示
:: Set UTF-8 encoding to support Chinese characters
chcp 65001 >nul 2>&1

:: 显示欢迎界面 / Display welcome screen
echo ================================================================
echo                    Kimi CC Windows 安装脚本
echo                 Kimi CC Windows Installation Script
echo ================================================================
echo 这个脚本将自动安装和配置 Claude Code 以使用 Kimi API
echo This script will automatically install and configure Claude Code to use Kimi API
echo.
echo 官方文档 / Official docs: https://github.com/sxyseo/kimi-cc
echo Kimi 开放平台 / Kimi Platform: https://platform.moonshot.cn/
echo ================================================================
echo.

:: ================================================================
:: 权限检查 / Permission Check
:: ================================================================
echo [检查 / Checking] 管理员权限 / Administrator privileges...

:: 检查管理员权限（可选，但推荐用于设置环境变量）
:: Check administrator privileges (optional but recommended for setting environment variables)
net session >nul 2>&1
if !errorLevel! neq 0 (
    echo [警告 / WARNING] 当前不是管理员权限运行 / Not running with administrator privileges
    echo 建议以管理员身份运行此脚本以确保环境变量正确设置
    echo Recommend running this script as administrator to ensure environment variables are set correctly
    echo 如果遇到权限问题，请右键"以管理员身份运行"
    echo If you encounter permission issues, right-click "Run as administrator"
    echo.
    pause
    echo 继续安装... / Continuing installation...
    echo.
) else (
    echo [成功 / SUCCESS] 管理员权限确认 / Administrator privileges confirmed
)

:: ================================================================
:: 第一步：检查 Node.js 安装状态 / Step 1: Check Node.js Installation
:: ================================================================
echo.
echo [步骤 / Step 1/5] 检查 Node.js 安装状态 / Checking Node.js installation status...

:: 检查 Node.js 是否已安装
:: Check if Node.js is installed
where node >nul 2>&1
if !errorLevel! neq 0 (
    echo [错误 / ERROR] 未检测到 Node.js / Node.js not detected
    echo.
    echo 请先安装 Node.js v18 或更高版本 / Please install Node.js v18 or higher:
    echo 1. 访问 / Visit: https://nodejs.org/
    echo 2. 下载并安装 LTS 版本 / Download and install LTS version
    echo 3. 安装完成后重新运行此脚本 / Re-run this script after installation
    echo.
    pause
    exit /b 1
)

:: 获取当前 Node.js 版本 / Get current Node.js version
for /f "delims=" %%i in ('node -v') do set node_version=%%i
set node_version=!node_version:v=!

:: 提取主版本号 / Extract major version number
for /f "tokens=1 delims=." %%a in ("!node_version!") do set major_version=%%a

:: 检查版本是否满足要求（>=18）/ Check if version meets requirements (>=18)
if !major_version! lss 18 (
    echo [错误 / ERROR] 检测到 Node.js v!node_version!，但需要 v18 或更高版本
    echo Detected Node.js v!node_version!, but requires v18 or higher
    echo 请更新您的 Node.js 版本后重新运行此脚本
    echo Please update your Node.js version and re-run this script
    pause
    exit /b 1
) else (
    echo [成功 / SUCCESS] 检测到 Node.js v!node_version! ^(满足要求 / meets requirements^)
)

:: 检查 npm 状态 / Check npm status
where npm >nul 2>&1
if !errorLevel! neq 0 (
    echo [错误 / ERROR] npm 未找到，请检查 Node.js 安装
    echo npm not found, please check Node.js installation
    pause
    exit /b 1
)

for /f "delims=" %%i in ('npm -v') do set npm_version=%%i
echo [信息 / INFO] npm 版本 / version: v!npm_version!

:: ================================================================
:: 第二步：检查和安装 Claude Code / Step 2: Check and Install Claude Code
:: ================================================================
echo.
echo [步骤 / Step 2/5] 检查 Claude Code 安装状态 / Checking Claude Code installation status...

:: 检查 Claude Code 是否已安装
:: Check if Claude Code is installed
where claude >nul 2>&1
if !errorLevel! neq 0 (
    echo [信息 / INFO] Claude Code 未安装，开始安装... / Claude Code not installed, starting installation...
    echo 正在执行 / Executing: npm install -g @anthropic-ai/claude-code
    echo.
    
    :: 执行安装命令 / Execute installation command
    npm install -g @anthropic-ai/claude-code
    if !errorLevel! neq 0 (
        echo.
        echo [错误 / ERROR] Claude Code 安装失败 / Claude Code installation failed
        echo 可能的解决方案 / Possible solutions:
        echo 1. 以管理员身份运行此脚本 / Run this script as administrator
        echo 2. 检查网络连接 / Check network connection
        echo 3. 尝试手动运行 / Try manual execution: npm install -g @anthropic-ai/claude-code
        echo 4. 清除 npm 缓存 / Clear npm cache: npm cache clean --force
        pause
        exit /b 1
    )
    echo [成功 / SUCCESS] Claude Code 安装完成 / Claude Code installation completed
) else (
    echo [信息 / INFO] Claude Code 已安装 / Claude Code already installed
    
    :: 尝试获取版本信息 / Try to get version information
    for /f "delims=" %%i in ('claude --version 2^>nul') do set claude_version=%%i
    if defined claude_version (
        echo [信息 / INFO] 当前版本 / Current version: !claude_version!
    ) else (
        echo [信息 / INFO] 无法获取版本信息，但claude命令可用 / Cannot get version info, but claude command is available
    )
)

:: ================================================================
:: 第三步：配置 Claude Code 跳过引导 / Step 3: Configure Claude Code to Skip Onboarding
:: ================================================================
echo.
echo [步骤 / Step 3/5] 配置 Claude Code 跳过引导设置 / Configuring Claude Code to skip onboarding...

:: 获取用户主目录 / Get user home directory
set "user_home=%USERPROFILE%"
set "claude_config=!user_home!\.claude.json"

:: 使用 PowerShell 创建或更新配置文件
:: Use PowerShell to create or update configuration file
echo 正在配置 .claude.json 文件... / Configuring .claude.json file...

:: 执行PowerShell命令，带有完整的错误处理
:: Execute PowerShell command with comprehensive error handling
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $homeDir = $env:USERPROFILE; $filePath = Join-Path $homeDir '.claude.json'; Write-Host 'Config path:' $filePath; if (Test-Path $filePath) { Write-Host 'Updating existing config...'; $content = Get-Content $filePath -Raw | ConvertFrom-Json; $content | Add-Member -Name 'hasCompletedOnboarding' -Value $true -MemberType NoteProperty -Force; $content | ConvertTo-Json -Depth 10 | Set-Content $filePath -Encoding UTF8; Write-Host 'Config updated successfully' } else { Write-Host 'Creating new config...'; @{hasCompletedOnboarding=$true} | ConvertTo-Json | Set-Content $filePath -Encoding UTF8; Write-Host 'Config created successfully' }; exit 0 } catch { Write-Host 'Error:' $_.Exception.Message; exit 1 }"

if !errorLevel! neq 0 (
    echo [警告 / WARNING] 配置文件设置可能失败，但不影响后续使用
    echo Configuration file setup may have failed, but does not affect subsequent use
    echo 您可以稍后手动运行 claude 命令完成配置
    echo You can manually run claude command later to complete configuration
) else (
    echo [成功 / SUCCESS] Claude Code 配置完成 / Claude Code configuration completed
)

:: ================================================================
:: 第四步：获取 Moonshot API Key / Step 4: Get Moonshot API Key
:: ================================================================
echo.
echo [步骤 / Step 4/5] 配置 Moonshot API Key / Configuring Moonshot API Key...
echo.
echo 🔑 请输入您的 Moonshot API Key / Please enter your Moonshot API Key:
echo    获取地址 / Get from: https://platform.moonshot.cn/console/api-keys
echo    说明 / Instructions: 用户中心 ^> API Key 管理 ^> 创建新的 API Key
echo                        User Center ^> API Key Management ^> Create New API Key
echo.
echo [注意 / NOTE] 出于安全考虑，输入时不会显示字符，请直接粘贴后按回车
echo              For security, input will not be displayed, please paste directly and press Enter

:: 使用 PowerShell 安全地读取密码（不显示在屏幕上）
:: Use PowerShell to securely read password (not displayed on screen)
for /f "usebackq delims=" %%i in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $key = Read-Host -AsSecureString; $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($key); $plaintext = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR); [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR); if ($plaintext.Length -eq 0) { Write-Output 'EMPTY_KEY' } else { Write-Output $plaintext } } catch { Write-Output 'ERROR_READING_KEY' }"`) do set api_key=%%i

:: 检查 API Key 是否为空或出错
:: Check if API Key is empty or error occurred
if "!api_key!"=="EMPTY_KEY" (
    echo.
    echo [错误 / ERROR] API Key 不能为空，请重新运行脚本
    echo API Key cannot be empty, please re-run the script
    pause
    exit /b 1
)

if "!api_key!"=="ERROR_READING_KEY" (
    echo.
    echo [错误 / ERROR] 读取 API Key 时出错，请重新运行脚本
    echo Error reading API Key, please re-run the script
    pause
    exit /b 1
)

:: 验证 API Key 格式（基本检查）
:: Validate API Key format (basic check)
if "!api_key:~0,3!" neq "sk-" (
    echo.
    echo [警告 / WARNING] API Key 格式可能不正确，通常以 'sk-' 开头
    echo API Key format may be incorrect, usually starts with 'sk-'
    echo 继续安装，但请确认 API Key 是否正确...
    echo Continuing installation, but please confirm if API Key is correct...
    echo.
    pause
)

echo.
echo [成功 / SUCCESS] API Key 已获取 / API Key obtained

:: ================================================================
:: 第五步：设置环境变量 / Step 5: Set Environment Variables
:: ================================================================
echo.
echo [步骤 / Step 5/5] 设置系统环境变量 / Setting system environment variables...

:: 环境变量值定义 / Environment variable values definition
set "base_url=https://api.moonshot.cn/anthropic/"

echo 正在设置环境变量... / Setting environment variables...

:: 方法1：为当前会话设置环境变量（立即生效）
:: Method 1: Set environment variables for current session (immediate effect)
echo [1/3] 设置当前会话环境变量 / Setting current session environment variables...
set "ANTHROPIC_BASE_URL=!base_url!"
set "ANTHROPIC_API_KEY=!api_key!"

:: 方法2：使用 setx 命令设置用户环境变量（永久生效）
:: Method 2: Use setx command to set user environment variables (permanent effect)
echo [2/3] 设置永久用户环境变量 / Setting permanent user environment variables...

setx ANTHROPIC_BASE_URL "!base_url!" >nul 2>&1
if !errorLevel! neq 0 (
    echo [警告 / WARNING] 永久设置 ANTHROPIC_BASE_URL 失败 / Failed to permanently set ANTHROPIC_BASE_URL
    set "setx_failed=1"
) else (
    echo [成功 / SUCCESS] ANTHROPIC_BASE_URL 永久设置成功 / ANTHROPIC_BASE_URL permanently set successfully
)

setx ANTHROPIC_API_KEY "!api_key!" >nul 2>&1
if !errorLevel! neq 0 (
    echo [警告 / WARNING] 永久设置 ANTHROPIC_API_KEY 失败 / Failed to permanently set ANTHROPIC_API_KEY
    set "setx_failed=1"
) else (
    echo [成功 / SUCCESS] ANTHROPIC_API_KEY 永久设置成功 / ANTHROPIC_API_KEY permanently set successfully
)

:: 方法3：验证环境变量设置 / Method 3: Verify environment variable settings
echo [3/3] 验证环境变量设置 / Verifying environment variable settings...
echo.

echo 当前会话环境变量 / Current session environment variables:
echo   ANTHROPIC_BASE_URL: !ANTHROPIC_BASE_URL!
echo   ANTHROPIC_API_KEY: !api_key:~0,8!****** (前8个字符 / first 8 characters shown)

:: 检查变量是否正确设置 / Check if variables are correctly set
if "!ANTHROPIC_BASE_URL!"=="!base_url!" (
    echo [✓] BASE_URL 设置正确 / BASE_URL set correctly
) else (
    echo [✗] BASE_URL 设置失败 / BASE_URL setting failed
    set "env_error=1"
)

if "!ANTHROPIC_API_KEY!"=="!api_key!" (
    echo [✓] API_KEY 设置正确 / API_KEY set correctly
) else (
    echo [✗] API_KEY 设置失败 / API_KEY setting failed
    set "env_error=1"
)

:: 如果有错误，跳转到手动设置说明 / If there are errors, jump to manual setup instructions
if defined env_error (
    echo.
    echo [错误 / ERROR] 环境变量设置存在问题 / Environment variable setup has issues
    goto :env_manual
)

if defined setx_failed (
    echo.
    echo [警告 / WARNING] 永久环境变量设置部分失败，但当前会话可用
    echo Permanent environment variable setup partially failed, but current session is available
    goto :env_manual_guide
)

echo.
echo [成功 / SUCCESS] 环境变量设置完成 / Environment variables set successfully
echo                （当前会话和永久设置均成功 / both current session and permanent settings successful）
goto :installation_complete

:: ================================================================
:: 手动设置环境变量指南 / Manual Environment Variable Setup Guide
:: ================================================================
:env_manual
echo.
echo ================================================================
echo           环境变量手动设置指南 / Manual Environment Variable Setup Guide
echo ================================================================
echo [错误 / ERROR] 自动设置环境变量失败，请手动设置 / Automatic environment variable setup failed, please set manually
echo.

:env_manual_guide
echo 🔧 手动设置方法 / Manual Setup Methods:
echo.
echo 方法 1 - 图形界面设置 / Method 1 - GUI Setup:
echo   1. 右键"此电脑" ^> 属性 ^> 高级系统设置 ^> 环境变量
echo      Right-click "This PC" ^> Properties ^> Advanced System Settings ^> Environment Variables
echo   2. 在"用户变量"中添加以下变量 / Add the following variables in "User Variables":
echo.
echo      变量名 / Variable Name: ANTHROPIC_BASE_URL
echo      变量值 / Variable Value: !base_url!
echo.
echo      变量名 / Variable Name: ANTHROPIC_API_KEY
echo      变量值 / Variable Value: !api_key!
echo.

echo 方法 2 - 命令行设置（当前会话）/ Method 2 - Command Line Setup (Current Session):
echo   在 CMD 中运行 / Run in CMD:
echo     set ANTHROPIC_BASE_URL=!base_url!
echo     set ANTHROPIC_API_KEY=!api_key!
echo.

echo 方法 3 - PowerShell 设置（当前会话）/ Method 3 - PowerShell Setup (Current Session):
echo   在 PowerShell 中运行 / Run in PowerShell:
echo     $env:ANTHROPIC_BASE_URL="!base_url!"
echo     $env:ANTHROPIC_API_KEY="!api_key!"
echo.

echo 方法 4 - 创建环境变量批处理文件 / Method 4 - Create Environment Variable Batch File:
echo   创建一个 .bat 文件包含以下内容 / Create a .bat file with the following content:
echo     @echo off
echo     set ANTHROPIC_BASE_URL=!base_url!
echo     set ANTHROPIC_API_KEY=!api_key!
echo     echo 环境变量已设置 / Environment variables set
echo.

goto :installation_complete

:: ================================================================
:: 安装完成 / Installation Complete
:: ================================================================
:installation_complete
echo.
echo ================================================================
echo                        🎉 安装完成！ / Installation Complete!
echo ================================================================
echo.
echo ✅ 安装摘要 / Installation Summary:
echo    Node.js 版本 / version: v!node_version!
echo    Claude Code: 已安装并配置 / Installed and configured
echo    环境变量 / Environment variables: 已设置 / Set
echo    API Key: 已配置 / Configured
echo.

echo 📝 使用说明 / Usage Instructions:
echo.
echo 🔸 在当前窗口中测试 / Test in current window:
echo    可以立即在此窗口运行 / You can run immediately in this window:
echo      claude --version
echo      claude
echo.

echo 🔸 在新窗口中使用 / Use in new window:
echo    1. 打开新的命令提示符或PowerShell窗口
echo       Open new Command Prompt or PowerShell window
echo    2. 运行命令 / Run command: claude
echo    3. 开始使用低成本的 Claude Code 服务！
echo       Start using low-cost Claude Code service!
echo.

echo 💡 故障排除 / Troubleshooting:
echo.
echo 🔹 如果遇到 "claude 不是内部或外部命令" 错误：
echo    If you encounter "claude is not recognized as internal or external command" error:
echo    • 尝试 / Try: npm list -g @anthropic-ai/claude-code
echo    • 重新安装 / Reinstall: npm install -g @anthropic-ai/claude-code
echo    • 重启命令行窗口 / Restart command line window
echo.

echo 🔹 如果遇到 "Invalid API key" 错误：
echo    If you encounter "Invalid API key" error:
echo    • 检查 API Key 是否正确 / Check if API Key is correct
echo    • 访问 / Visit: https://platform.moonshot.cn/console/api-keys
echo    • 重新运行此脚本 / Re-run this script
echo.

echo 🔹 如果环境变量未生效：
echo    If environment variables are not effective:
echo    • 重启命令行窗口 / Restart command line window
echo    • 重新登录系统 / Re-login to system
echo    • 按照上面的手动设置方法 / Follow manual setup methods above
echo.

echo ================================================================
echo                     🧪 快速环境测试 / Quick Environment Test
echo ================================================================
echo 您可以运行以下命令测试环境变量是否正常工作：
echo You can run the following commands to test if environment variables are working:
echo.
echo 在 CMD 中 / In CMD:
echo   echo %%ANTHROPIC_BASE_URL%%
echo   echo %%ANTHROPIC_API_KEY%%
echo.
echo 在 PowerShell 中 / In PowerShell:
echo   echo $env:ANTHROPIC_BASE_URL
echo   echo $env:ANTHROPIC_API_KEY
echo.
echo 预期输出 / Expected output:
echo   !base_url!
echo   (你的 API key / your API key)
echo.
echo 如果看到实际值而不是变量名，说明环境变量工作正常！
echo If you see actual values instead of variable names, environment variables are working correctly!
echo ================================================================
echo.

echo 🔗 相关链接 / Related Links:
echo    • Kimi 开放平台 / Kimi Open Platform: https://platform.moonshot.cn/
echo    • 项目主页 / Project Homepage: https://github.com/sxyseo/kimi-cc
echo    • Claude Code 文档 / Claude Code Documentation: https://docs.anthropic.com/claude/docs
echo.

echo 感谢使用 Kimi CC！ / Thank you for using Kimi CC!
echo 如有问题请访问项目主页获取支持。 / For issues, please visit the project homepage for support.
echo.
pause 