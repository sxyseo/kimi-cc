@echo off
:: =================================================================
:: Claude Code Multi-Provider Windows Installation Script
:: =================================================================
:: Project: https://github.com/sxyseo/qwen-cc
:: Description: Automatically install and configure Claude Code with multiple API providers
:: Version: 2.0
:: Author: LLM Red Team
:: =================================================================

:: Enable delayed variable expansion for handling variables in loops and conditionals
setlocal enabledelayedexpansion

:: Display welcome screen
echo ================================================================
echo         Claude Code Multi-Provider Windows Installation Script
echo ================================================================
echo This script will automatically install and configure Claude Code with your choice of API provider
echo.
echo Supported providers: Qwen3 (default), Kimi, Custom
echo Official docs: https://github.com/sxyseo/qwen-cc
echo ================================================================
echo.

:: ================================================================
:: Permission Check
:: ================================================================
echo [Checking] Administrator privileges...

:: Check administrator privileges (optional but recommended for setting environment variables)
net session >nul 2>&1
if !errorLevel! neq 0 (
    echo [WARNING] Not running with administrator privileges
    echo Recommend running this script as administrator to ensure environment variables are set correctly
    echo If you encounter permission issues, right-click "Run as administrator"
    echo.
    pause
    echo Continuing installation...
    echo.
) else (
    echo [SUCCESS] Administrator privileges confirmed
)

:: ================================================================
:: Step 1: Check Node.js Installation
:: ================================================================
echo.
echo [Step 1/5] Checking Node.js installation status...

:: Check if Node.js is installed
where node >nul 2>&1
if !errorLevel! neq 0 (
    echo [ERROR] Node.js not detected
    echo.
    echo Please install Node.js v18 or higher:
    echo 1. Visit: https://nodejs.org/
    echo 2. Download and install LTS version
    echo 3. Re-run this script after installation
    echo.
    pause
    exit /b 1
)

:: Get current Node.js version
for /f "delims=" %%i in ('node -v') do set node_version=%%i
set node_version=!node_version:v=!

:: Extract major version number
for /f "tokens=1 delims=." %%a in ("!node_version!") do set major_version=%%a

:: Check if version meets requirements (>=18)
if !major_version! lss 18 (
    echo [ERROR] Detected Node.js v!node_version!, but requires v18 or higher
    echo Please update your Node.js version and re-run this script
    pause
    exit /b 1
) else (
    echo [SUCCESS] Detected Node.js v!node_version! (meets requirements)
)

:: Check npm status
where npm >nul 2>&1
if !errorLevel! neq 0 (
    echo [ERROR] npm not found, please check Node.js installation
    pause
    exit /b 1
)

for /f "delims=" %%i in ('npm -v') do set npm_version=%%i
echo [INFO] npm version: v!npm_version!

:: ================================================================
:: Step 2: Check and Install Claude Code
:: ================================================================
echo.
echo [Step 2/5] Checking Claude Code installation status...

:: Check if Claude Code is installed
where claude >nul 2>&1
if !errorLevel! neq 0 (
    echo [INFO] Claude Code not installed, starting installation...
    echo Executing: npm install -g @anthropic-ai/claude-code
    echo.

    :: Execute installation command
    npm install -g @anthropic-ai/claude-code
    if !errorLevel! neq 0 (
        echo.
        echo [ERROR] Claude Code installation failed
        echo Possible solutions:
        echo 1. Run this script as administrator
        echo 2. Check network connection
        echo 3. Try manual execution: npm install -g @anthropic-ai/claude-code
        echo 4. Clear npm cache: npm cache clean --force
        pause
        exit /b 1
    )
    echo [SUCCESS] Claude Code installation completed
) else (
    echo [INFO] Claude Code already installed

    :: Try to get version information
    for /f "delims=" %%i in ('claude --version 2^>nul') do set claude_version=%%i
    if defined claude_version (
        echo [INFO] Current version: !claude_version!
    ) else (
        echo [INFO] Cannot get version info, but claude command is available
    )
)

:: ================================================================
:: Step 3: Configure Claude Code to Skip Onboarding
:: ================================================================
echo.
echo [Step 3/5] Configuring Claude Code to skip onboarding...

:: Get user home directory
set "user_home=%USERPROFILE%"
set "claude_config=!user_home!\.claude.json"

:: Use PowerShell to create or update configuration file
echo Configuring .claude.json file...

:: Execute PowerShell command with comprehensive error handling
powershell -NoProfile -ExecutionPolicy Bypass -Command "$homeDir = $env:USERPROFILE; $filePath = Join-Path $homeDir '.claude.json'; Write-Host 'Config path:' $filePath; if (Test-Path $filePath) { Write-Host 'Updating existing config...'; $content = Get-Content $filePath -Raw | ConvertFrom-Json; $content | Add-Member -Name 'hasCompletedOnboarding' -Value $true -MemberType NoteProperty -Force; $content | ConvertTo-Json -Depth 10 | Set-Content $filePath -Encoding UTF8; Write-Host 'Config updated successfully' } else { Write-Host 'Creating new config...'; @{hasCompletedOnboarding=$true} | ConvertTo-Json | Set-Content $filePath -Encoding UTF8; Write-Host 'Config created successfully' }"

if !errorLevel! neq 0 (
    echo [WARNING] Configuration file setup may have failed, but does not affect subsequent use
    echo You can manually run claude command later to complete configuration
) else (
    echo [SUCCESS] Claude Code configuration completed
)

:: ================================================================
:: Step 4: Configure BASE_URL
:: ================================================================
echo.
echo [Step 4/6] Configuring API Provider...
echo.
echo Please choose your API provider:
echo   1. Qwen3 (Alibaba DashScope) - Default and recommended
echo   2. Kimi (Moonshot AI)
echo   3. Custom BASE_URL
echo.
set /p "base_url_choice=Choose option (1, 2, or 3, default: 1): "

:: Handle empty input (default to 1)
if "!base_url_choice!"=="" set base_url_choice=1

:: Set BASE_URL and provider info based on choice
if "!base_url_choice!"=="2" (
    set "base_url=https://api.moonshot.cn/anthropic/"
    set "api_provider=Kimi"
    set "api_key_url=https://platform.moonshot.cn/console/api-keys"
    set "api_key_prefix=sk-"
    echo [SUCCESS] Using Kimi BASE_URL: !base_url!
) else if "!base_url_choice!"=="3" (
    echo.
    echo Please enter your custom BASE_URL:
    set /p "base_url=BASE_URL: "
    if "!base_url!"=="" (
        echo [WARNING] BASE_URL cannot be empty. Using default Qwen3 BASE_URL.
        set "base_url=https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
        set "api_provider=Qwen3"
        set "api_key_url=https://dashscope.console.aliyun.com/apiKey"
        set "api_key_prefix=sk-"
    ) else (
        set "api_provider=Custom"
        set "api_key_url=Please refer to your API provider's documentation"
        set "api_key_prefix="
    )
    echo [SUCCESS] Using custom BASE_URL: !base_url!
) else (
    set "base_url=https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy"
    set "api_provider=Qwen3"
    set "api_key_url=https://dashscope.console.aliyun.com/apiKey"
    set "api_key_prefix=sk-"
    echo [SUCCESS] Using default Qwen3 BASE_URL: !base_url!
)

:: ================================================================
:: Step 5: Get API Key
:: ================================================================
echo.
echo [Step 5/6] Configuring !api_provider! API Key...
echo.
echo Please enter your !api_provider! API Key:
echo Get from: !api_key_url!
if "!api_provider!"=="Kimi" (
    echo Instructions: User Center ^> API Key Management ^> Create New API Key
) else if "!api_provider!"=="Qwen3" (
    echo Instructions: Console ^> API Key Management ^> Create API Key
) else (
    echo Instructions: Please refer to your API provider's documentation
)
echo.
echo [NOTE] For security, input will not be displayed, please paste directly and press Enter

:: Use PowerShell to securely read password (not displayed on screen)
for /f "usebackq delims=" %%i in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$key = Read-Host -AsSecureString; $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($key); $plaintext = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR); [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR); if ($plaintext.Length -eq 0) { Write-Output 'EMPTY_KEY' } else { Write-Output $plaintext }"`) do set api_key=%%i

:: Check if API Key is empty or error occurred
if "!api_key!"=="EMPTY_KEY" (
    echo.
    echo [ERROR] API Key cannot be empty, please re-run the script
    pause
    exit /b 1
)

:: Validate API Key format (basic check) - only for providers that use sk- prefix
if not "!api_key_prefix!"=="" (
    if "!api_key:~0,3!" neq "!api_key_prefix!" (
        echo.
        echo [WARNING] API Key format may be incorrect, usually starts with '!api_key_prefix!'
        echo Continuing installation, but please confirm if API Key is correct...
        echo.
        pause
    )
)

echo.
echo [SUCCESS] API Key obtained

:: ================================================================
:: Step 6: Set Environment Variables
:: ================================================================
echo.
echo [Step 6/6] Setting system environment variables...

:: Environment variable values are already set in previous step (base_url variable)

echo Setting environment variables...

:: Method 1: Set environment variables for current session (immediate effect)
echo [1/3] Setting current session environment variables...
set "ANTHROPIC_BASE_URL=!base_url!"
set "ANTHROPIC_API_KEY=!api_key!"

:: Method 2: Use setx command to set user environment variables (permanent effect)
echo [2/3] Setting permanent user environment variables...

setx ANTHROPIC_BASE_URL "!base_url!" >nul 2>&1
if !errorLevel! neq 0 (
    echo [WARNING] Failed to permanently set ANTHROPIC_BASE_URL
    set "setx_failed=1"
) else (
    echo [SUCCESS] ANTHROPIC_BASE_URL permanently set successfully
)

setx ANTHROPIC_API_KEY "!api_key!" >nul 2>&1
if !errorLevel! neq 0 (
    echo [WARNING] Failed to permanently set ANTHROPIC_API_KEY
    set "setx_failed=1"
) else (
    echo [SUCCESS] ANTHROPIC_API_KEY permanently set successfully
)

:: Method 3: Verify environment variable settings
echo [3/3] Verifying environment variable settings...
echo.

echo Current session environment variables:
echo   ANTHROPIC_BASE_URL: !ANTHROPIC_BASE_URL!
echo   ANTHROPIC_API_KEY: !api_key:~0,8!****** (first 8 characters shown)

:: Check if variables are correctly set
if "!ANTHROPIC_BASE_URL!"=="!base_url!" (
    echo [✓] BASE_URL set correctly
) else (
    echo [✗] BASE_URL setting failed
    set "env_error=1"
)

if "!ANTHROPIC_API_KEY!"=="!api_key!" (
    echo [✓] API_KEY set correctly
) else (
    echo [✗] API_KEY setting failed
    set "env_error=1"
)

:: If there are errors, jump to manual setup instructions
if defined env_error (
    echo.
    echo [ERROR] Environment variable setup has issues
    goto :env_manual
)

if defined setx_failed (
    echo.
    echo [WARNING] Permanent environment variable setup partially failed, but current session is available
    goto :env_manual_guide
)

echo.
echo [SUCCESS] Environment variables set successfully
echo           (both current session and permanent settings successful)
goto :installation_complete

:: ================================================================
:: Manual Environment Variable Setup Guide
:: ================================================================
:env_manual
echo.
echo ================================================================
echo           Manual Environment Variable Setup Guide
echo ================================================================
echo [ERROR] Automatic environment variable setup failed, please set manually
echo.

:env_manual_guide
echo Manual Setup Methods:
echo.
echo Method 1 - GUI Setup:
echo   1. Right-click "This PC" ^> Properties ^> Advanced System Settings ^> Environment Variables
echo   2. Add the following variables in "User Variables":
echo.
echo      Variable Name: ANTHROPIC_BASE_URL
echo      Variable Value: !base_url!
echo.
echo      Variable Name: ANTHROPIC_API_KEY
echo      Variable Value: !api_key!
echo.

echo Method 2 - Command Line Setup (Current Session):
echo   Run in CMD:
echo     set ANTHROPIC_BASE_URL=!base_url!
echo     set ANTHROPIC_API_KEY=!api_key!
echo.

echo Method 3 - PowerShell Setup (Current Session):
echo   Run in PowerShell:
echo     $env:ANTHROPIC_BASE_URL="!base_url!"
echo     $env:ANTHROPIC_API_KEY="!api_key!"
echo.

echo Method 4 - Create Environment Variable Batch File:
echo   Create a .bat file with the following content:
echo     @echo off
echo     set ANTHROPIC_BASE_URL=!base_url!
echo     set ANTHROPIC_API_KEY=!api_key!
echo     echo Environment variables set
echo.

goto :installation_complete

:: ================================================================
:: Installation Complete
:: ================================================================
:installation_complete
echo.
echo ================================================================
echo                        Installation Complete!
echo ================================================================
echo.
echo Installation Summary:
echo    Node.js version: v!node_version!
echo    Claude Code: Installed and configured
echo    Environment variables: Set
echo    API Key: Configured
echo.

echo Usage Instructions:
echo.
echo Test in current window:
echo    You can run immediately in this window:
echo      claude --version
echo      claude
echo.

echo Use in new window:
echo    1. Open new Command Prompt or PowerShell window
echo    2. Run command: claude
echo    3. Start using low-cost Claude Code service!
echo.

echo Troubleshooting:
echo.
echo If you encounter "claude is not recognized as internal or external command" error:
echo    • Try: npm list -g @anthropic-ai/claude-code
echo    • Reinstall: npm install -g @anthropic-ai/claude-code
echo    • Restart command line window
echo.

echo If you encounter "Invalid API key" error:
echo    • Check if API Key is correct
echo    • Visit: !api_key_url!
echo    • Re-run this script
echo.

echo If environment variables are not effective:
echo    • Restart command line window
echo    • Re-login to system
echo    • Follow manual setup methods above
echo.

echo ================================================================
echo                     Quick Environment Test
echo ================================================================
echo You can run the following commands to test if environment variables are working:
echo.
echo In CMD:
echo   echo %%ANTHROPIC_BASE_URL%%
echo   echo %%ANTHROPIC_API_KEY%%
echo.
echo In PowerShell:
echo   echo $env:ANTHROPIC_BASE_URL
echo   echo $env:ANTHROPIC_API_KEY
echo.
echo Expected output:
echo   !base_url!
echo   (your API key)
echo.
echo If you see actual values instead of variable names, environment variables are working correctly!
echo ================================================================
echo.

echo Related Links:
if "!api_provider!"=="Kimi" (
    echo    • Kimi Open Platform: https://platform.moonshot.cn/
) else if "!api_provider!"=="Qwen3" (
    echo    • Qwen3 DashScope Platform: https://dashscope.console.aliyun.com/
) else (
    echo    • API Provider: !api_key_url!
)
echo    • Project Homepage: https://github.com/sxyseo/qwen-cc
echo    • Claude Code Documentation: https://docs.anthropic.com/claude/docs
echo.

echo Thank you for using Claude Code Multi-Provider Installation!
echo For issues, please visit the project homepage for support.
echo.
pause
