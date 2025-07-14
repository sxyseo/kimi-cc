@echo off
:: 强制设置控制台代码页为UTF-8
chcp 65001 >nul 2>&1
:: 设置批处理文件编码环境
set "LANG=zh_CN.UTF-8"

echo ================================================================
echo                    Kimi CC Windows 安装脚本
echo ================================================================
echo 该脚本将自动安装和配置 Claude Code 以使用 Kimi API
echo 官方文档: https://github.com/LLM-Red-Team/kimi-cc
echo ================================================================
echo.

:: 检查管理员权限（可选，但推荐用于设置环境变量）
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [警告] 当前不是管理员权限运行
    echo 建议以管理员身份运行此脚本以确保环境变量正确设置
    echo 如果遇到权限问题，请右键"以管理员身份运行"
    echo.
    pause
    echo 继续安装...
    echo.
)

:: ================================================================
:: 第一步：检查 Node.js 安装状态
:: ================================================================
echo [步骤 1/5] 检查 Node.js 安装状态...

:: 检查 Node.js 是否已安装
where node >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] 未检测到 Node.js
    echo.
    echo 请先安装 Node.js v18 或更高版本：
    echo 1. 访问 https://nodejs.org/
    echo 2. 下载并安装 LTS 版本
    echo 3. 安装完成后重新运行此脚本
    echo.
    pause
    exit /b 1
)

:: 获取当前 Node.js 版本
for /f "delims=" %%i in ('node -v') do set node_version=%%i
set node_version=%node_version:v=%

:: 提取主版本号
for /f "tokens=1 delims=." %%a in ("%node_version%") do set major_version=%%a

:: 检查版本是否满足要求（>=18）
if %major_version% lss 18 (
    echo [错误] 检测到 Node.js v%node_version%，但需要 v18 或更高版本
    echo 请更新您的 Node.js 版本后重新运行此脚本
    pause
    exit /b 1
) else (
    echo [成功] 检测到 Node.js v%node_version% ^(满足要求^)
)

:: 检查 npm 状态
where npm >nul 2>&1
if %errorLevel% neq 0 (
    echo [错误] npm 未找到，请检查 Node.js 安装
    pause
    exit /b 1
)

for /f "delims=" %%i in ('npm -v') do set npm_version=%%i
echo [信息] npm 版本: v%npm_version%
echo.

:: ================================================================
:: 第二步：检查和安装 Claude Code
:: ================================================================
echo [步骤 2/5] 检查 Claude Code 安装状态...

:: 检查 Claude Code 是否已安装
where claude >nul 2>&1
if %errorLevel% neq 0 (
    echo [信息] Claude Code 未安装，开始安装...
    echo 正在执行: npm install -g @anthropic-ai/claude-code
    npm install -g @anthropic-ai/claude-code
    if %errorLevel% neq 0 (
        echo [错误] Claude Code 安装失败
        echo 可能的解决方案:
        echo 1. 以管理员身份运行此脚本
        echo 2. 检查网络连接
        echo 3. 尝试手动运行: npm install -g @anthropic-ai/claude-code
        pause
        exit /b 1
    )
    echo [成功] Claude Code 安装完成
) else (
    echo [信息] Claude Code 已安装
    for /f "delims=" %%i in ('claude --version 2^>nul') do set claude_version=%%i
    if defined claude_version (
        echo [信息] 当前版本: %claude_version%
    )
)
echo.

:: ================================================================
:: 第三步：配置 Claude Code 跳过引导
:: ================================================================
echo [步骤 3/5] 配置 Claude Code 跳过引导设置...

:: 获取用户主目录
set "user_home=%USERPROFILE%"
set "claude_config=%user_home%\.claude.json"

:: 使用 PowerShell 创建或更新配置文件
echo 正在配置 .claude.json 文件...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$homeDir = $env:USERPROFILE; $filePath = Join-Path $homeDir '.claude.json'; if (Test-Path $filePath) { $content = Get-Content $filePath -Raw | ConvertFrom-Json; $content | Add-Member -Name 'hasCompletedOnboarding' -Value $true -MemberType NoteProperty -Force; $content | ConvertTo-Json | Set-Content $filePath } else { @{hasCompletedOnboarding=$true} | ConvertTo-Json | Set-Content $filePath }"

if %errorLevel% neq 0 (
    echo [警告] 配置文件设置可能失败，但不影响后续使用
) else (
    echo [成功] Claude Code 配置完成
)
echo.

:: ================================================================
:: 第四步：获取 Moonshot API Key
:: ================================================================
echo [步骤 4/5] 配置 Moonshot API Key...
echo.
echo 🔑 请输入您的 Moonshot API Key:
echo    获取地址: https://platform.moonshot.cn/console/api-keys
echo    说明: 在 Kimi 开放平台用户中心 ^> API Key 管理 ^> 创建新的 API Key
echo.
echo [注意] 出于安全考虑，输入时不会显示字符，请直接粘贴后按回车

:: 使用 PowerShell 安全地读取密码（不显示在屏幕上）
for /f "delims=" %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "$key = Read-Host -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($key))"') do set api_key=%%i

:: 检查 API Key 是否为空
if "%api_key%"=="" (
    echo.
    echo [错误] API Key 不能为空，请重新运行脚本
    pause
    exit /b 1
)

echo.
echo [成功] API Key 已获取

:: ================================================================
:: 第五步：设置环境变量
:: ================================================================
echo [步骤 5/5] 设置系统环境变量...

:: 设置用户环境变量（推荐方式，不需要管理员权限）
echo 正在设置环境变量...

:: 使用 setx 命令设置用户环境变量
setx ANTHROPIC_BASE_URL "https://api.moonshot.cn/anthropic/" >nul
if %errorLevel% neq 0 (
    echo [错误] 设置 ANTHROPIC_BASE_URL 失败
    goto :env_manual
)

setx ANTHROPIC_API_KEY "%api_key%" >nul
if %errorLevel% neq 0 (
    echo [错误] 设置 ANTHROPIC_API_KEY 失败
    goto :env_manual
)

echo [成功] 环境变量设置完成
goto :installation_complete

:env_manual
echo.
echo [警告] 自动设置环境变量失败，请手动设置:
echo.
echo 1. 右键"此电脑" ^> 属性 ^> 高级系统设置 ^> 环境变量
echo 2. 在"用户变量"中添加以下变量:
echo.
echo    变量名: ANTHROPIC_BASE_URL
echo    变量值: https://api.moonshot.cn/anthropic/
echo.
echo    变量名: ANTHROPIC_API_KEY
echo    变量值: %api_key%
echo.

:installation_complete
:: ================================================================
:: 安装完成
:: ================================================================
echo.
echo ================================================================
echo                        🎉 安装完成！
echo ================================================================
echo.
echo ✅ Node.js 版本: v%node_version%
echo ✅ Claude Code 已安装并配置
echo ✅ 环境变量已设置
echo ✅ API Key 已配置
echo.
echo 📝 使用说明:
echo    1. 重新打开命令提示符/PowerShell 窗口
echo    2. 运行命令: claude
echo    3. 开始使用低成本的 Claude Code 服务！
echo.
echo 💡 提示:
echo    - 如果遇到 "claude 不是内部或外部命令" 错误
echo      请重新打开命令行窗口或重启计算机
echo    - 环境变量可能需要重新登录系统后才能生效
echo    - 如有问题请访问: https://platform.moonshot.cn/
echo.
echo 🔗 相关链接:
echo    - Kimi 开放平台: https://platform.moonshot.cn/
echo    - 项目主页: https://github.com/LLM-Red-Team/kimi-cc
echo.
pause 