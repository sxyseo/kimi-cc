@echo off
:: =================================================================
:: Claude Code Environment Cleanup Script for Windows
:: =================================================================
:: Project: https://github.com/sxyseo/qwen-cc
:: Description: Remove Claude Code environment variables and configuration
:: Version: 1.0
:: Author: LLM Red Team
:: =================================================================

:: Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Display welcome screen
echo ================================================================
echo           Claude Code Environment Cleanup Script
echo ================================================================
echo This script will remove Claude Code environment variables and configuration
echo ================================================================
echo.

:: ================================================================
:: Permission Check
:: ================================================================
echo [Checking] Administrator privileges...

:: Check administrator privileges (recommended for removing system environment variables)
net session >nul 2>&1
if !errorLevel! neq 0 (
    echo [WARNING] Not running with administrator privileges
    echo Recommend running this script as administrator to ensure environment variables are removed completely
    echo If you encounter permission issues, right-click "Run as administrator"
    echo.
    pause
    echo Continuing cleanup...
    echo.
) else (
    echo [SUCCESS] Administrator privileges confirmed
)

:: ================================================================
:: Step 1: Remove Environment Variables
:: ================================================================
echo.
echo [Step 1/2] Removing environment variables...

:: Track if any changes were made
set "changes_made=false"

:: Method 1: Remove user environment variables using reg command
echo [1/3] Removing user environment variables from registry...

:: Check if ANTHROPIC_BASE_URL exists in user environment
reg query "HKEY_CURRENT_USER\Environment" /v ANTHROPIC_BASE_URL >nul 2>&1
if !errorLevel! equ 0 (
    echo   Found ANTHROPIC_BASE_URL in user environment, removing...
    reg delete "HKEY_CURRENT_USER\Environment" /v ANTHROPIC_BASE_URL /f >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [SUCCESS] ANTHROPIC_BASE_URL removed from user environment
        set "changes_made=true"
    ) else (
        echo   [WARNING] Failed to remove ANTHROPIC_BASE_URL from user environment
    )
) else (
    echo   [INFO] ANTHROPIC_BASE_URL not found in user environment
)

:: Check if ANTHROPIC_API_KEY exists in user environment
reg query "HKEY_CURRENT_USER\Environment" /v ANTHROPIC_API_KEY >nul 2>&1
if !errorLevel! equ 0 (
    echo   Found ANTHROPIC_API_KEY in user environment, removing...
    reg delete "HKEY_CURRENT_USER\Environment" /v ANTHROPIC_API_KEY /f >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [SUCCESS] ANTHROPIC_API_KEY removed from user environment
        set "changes_made=true"
    ) else (
        echo   [WARNING] Failed to remove ANTHROPIC_API_KEY from user environment
    )
) else (
    echo   [INFO] ANTHROPIC_API_KEY not found in user environment
)

:: Method 2: Remove system environment variables (requires admin privileges)
echo [2/3] Checking system environment variables...

:: Check if running with admin privileges for system variables
net session >nul 2>&1
if !errorLevel! equ 0 (
    :: Check if ANTHROPIC_BASE_URL exists in system environment
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v ANTHROPIC_BASE_URL >nul 2>&1
    if !errorLevel! equ 0 (
        echo   Found ANTHROPIC_BASE_URL in system environment, removing...
        reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v ANTHROPIC_BASE_URL /f >nul 2>&1
        if !errorLevel! equ 0 (
            echo   [SUCCESS] ANTHROPIC_BASE_URL removed from system environment
            set "changes_made=true"
        ) else (
            echo   [WARNING] Failed to remove ANTHROPIC_BASE_URL from system environment
        )
    ) else (
        echo   [INFO] ANTHROPIC_BASE_URL not found in system environment
    )

    :: Check if ANTHROPIC_API_KEY exists in system environment
    reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v ANTHROPIC_API_KEY >nul 2>&1
    if !errorLevel! equ 0 (
        echo   Found ANTHROPIC_API_KEY in system environment, removing...
        reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v ANTHROPIC_API_KEY /f >nul 2>&1
        if !errorLevel! equ 0 (
            echo   [SUCCESS] ANTHROPIC_API_KEY removed from system environment
            set "changes_made=true"
        ) else (
            echo   [WARNING] Failed to remove ANTHROPIC_API_KEY from system environment
        )
    ) else (
        echo   [INFO] ANTHROPIC_API_KEY not found in system environment
    )
) else (
    echo   [INFO] Skipping system environment variables (requires administrator privileges)
)

:: Method 3: Clear environment variables from current session
echo [3/3] Clearing environment variables from current session...
set ANTHROPIC_BASE_URL=
set ANTHROPIC_API_KEY=
echo   [SUCCESS] Environment variables cleared from current session

:: ================================================================
:: Step 2: Remove Claude Configuration File
:: ================================================================
echo.
echo [Step 2/2] Removing Claude Code configuration file...

:: Get user home directory and claude config path
set "user_home=%USERPROFILE%"
set "claude_config=!user_home!\.claude.json"

:: Check if .claude.json exists
if exist "!claude_config!" (
    echo   Found Claude Code configuration file: !claude_config!
    
    :: Create backup with timestamp
    for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set backup_date=%%c%%a%%b
    for /f "tokens=1-2 delims=: " %%a in ('time /t') do set backup_time=%%a%%b
    set "backup_time=!backup_time: =!"
    set "backup_config=!claude_config!.backup.!backup_date!_!backup_time!"
    
    echo   Creating backup: !backup_config!
    copy "!claude_config!" "!backup_config!" >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [SUCCESS] Backup created successfully
        
        :: Remove the original file
        del "!claude_config!" >nul 2>&1
        if !errorLevel! equ 0 (
            echo   [SUCCESS] Claude Code configuration file removed
            set "changes_made=true"
        ) else (
            echo   [WARNING] Failed to remove Claude Code configuration file
        )
    ) else (
        echo   [WARNING] Failed to create backup, skipping file removal
    )
) else (
    echo   [INFO] Claude Code configuration file not found: !claude_config!
)

:: ================================================================
:: Cleanup Summary
:: ================================================================
echo.
echo ================================================================
echo                        Cleanup Summary
echo ================================================================

if "!changes_made!"=="true" (
    echo [SUCCESS] Cleanup completed successfully!
    echo.
    echo Summary of actions taken:
    echo   • Environment variables removed from Windows registry
    echo   • .claude.json configuration file removed
    echo   • Current session environment variables cleared
    echo   • Backup files created for safety
    echo.
    echo To ensure all changes take effect:
    echo   • Restart your command prompt/PowerShell, or
    echo   • Restart your computer for system-wide changes
    echo.
    echo Backup files location:
    echo   • Claude config backup: !user_home!\.claude.json.backup.*
) else (
    echo [INFO] No Claude Code environment variables or configuration found.
    echo       System is already clean.
)

echo.
echo Related cleanup actions you might want to consider:
echo   • Uninstall Claude Code: npm uninstall -g @anthropic-ai/claude-code
echo   • Clear npm cache: npm cache clean --force
echo.

echo ================================================================
echo                     Environment Variable Test
echo ================================================================
echo You can test if environment variables are removed by running:
echo.
echo In CMD:
echo   echo %%ANTHROPIC_BASE_URL%%
echo   echo %%ANTHROPIC_API_KEY%%
echo.
echo In PowerShell:
echo   echo $env:ANTHROPIC_BASE_URL
echo   echo $env:ANTHROPIC_API_KEY
echo.
echo Expected output: Empty or "Environment variable not defined"
echo ================================================================
echo.

echo Thank you for using Claude Code Environment Cleanup!
echo For issues, please visit: https://github.com/sxyseo/qwen-cc
echo.
pause
