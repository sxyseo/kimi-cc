@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: Claude Code Config Manager GUI Launcher
:: Auto check dependencies and start GUI

echo Claude Code Configuration Manager
echo ====================================

:: Check Python
where python >nul 2>&1
if %errorlevel% equ 0 (
    set "python_cmd=python"
    goto :check_gui
)

where python3 >nul 2>&1
if %errorlevel% equ 0 (
    set "python_cmd=python3"
    goto :check_gui
)

echo Error: Python not found
echo Please install Python: https://python.org
pause
exit /b 1

:check_gui
echo Checking GUI dependencies...

:: Check PySide6
%python_cmd% -c "import PySide6" >nul 2>&1
if %errorlevel% neq 0 (
    echo PySide6 dependency not found
    set /p "install_choice=Auto install GUI dependencies? (y/n): "
    
    if /i "!install_choice!"=="y" (
        echo Installing PySide6...
        %python_cmd% -m pip install PySide6
        if %errorlevel% neq 0 (
            echo Installation failed, please run manually: pip install PySide6
            pause
            exit /b 1
        )
        echo Dependencies installed successfully!
    ) else (
        echo Please install dependencies manually: pip install PySide6
        pause
        exit /b 1
    )
)

:: Start GUI
echo Starting configuration manager...
if exist "claude_config_gui.py" (
    %python_cmd% claude_config_gui.py
) else if exist "start_gui.py" (
    %python_cmd% start_gui.py
) else (
    echo Error: GUI file not found
    echo Please ensure claude_config_gui.py or start_gui.py is in current directory
    pause
    exit /b 1
)
