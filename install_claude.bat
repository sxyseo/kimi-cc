@echo off
:: =================================================================
:: Kimi CC Windows Installation Script
:: =================================================================
:: Project: https://github.com/sxyseo/kimi-cc
:: Description: Automatically install and configure Claude Code to use Kimi API
:: Version: 1.3
:: Author: LLM Red Team
:: =================================================================

:: Enable delayed variable expansion for handling variables in loops and conditionals
setlocal enabledelayedexpansion

:: Display welcome screen
echo ================================================================
echo                 Kimi CC Windows Installation Script
echo ================================================================
echo This script will automatically install and configure Claude Code to use Kimi API
echo.
echo Official docs: https://github.com/sxyseo/kimi-cc
echo Kimi Platform: https://platform.moonshot.cn/
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
:: Step 4: Get Moonshot API Key
:: ================================================================
echo.
echo [Step 4/5] Configuring Moonshot API Key...
echo.
echo Please enter your Moonshot API Key:
echo Get from: https://platform.moonshot.cn/console/api-keys
echo Instructions: User Center ^> API Key Management ^> Create New API Key
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

:: Validate API Key format (basic check)
if "!api_key:~0,3!" neq "sk-" (
    echo.
    echo [WARNING] API Key format may be incorrect, usually starts with 'sk-'
    echo Continuing installation, but please confirm if API Key is correct...
    echo.
    pause
)

echo.
echo [SUCCESS] API Key obtained

:: ================================================================
:: Step 5: Set Environment Variables
:: ================================================================
echo.
echo [Step 5/5] Setting system environment variables...

:: Environment variable values definition
set "base_url=https://api.moonshot.cn/anthropic/"

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
echo    • Visit: https://platform.moonshot.cn/console/api-keys
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
echo    • Kimi Open Platform: https://platform.moonshot.cn/
echo    • Project Homepage: https://github.com/sxyseo/kimi-cc
echo    • Claude Code Documentation: https://docs.anthropic.com/claude/docs
echo.

echo Thank you for using Kimi CC!
echo For issues, please visit the project homepage for support.
echo.
pause 