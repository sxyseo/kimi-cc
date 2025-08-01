@echo off
setlocal enabledelayedexpansion

echo Claude Code Configuration Manager
echo ==================================

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
echo Please install Python from https://python.org
pause
exit /b 1

:check_gui
echo Checking GUI dependencies...

%python_cmd% -c "import PySide6" >nul 2>&1
if %errorlevel% neq 0 (
    echo PySide6 not found
    set /p "install_choice=Install GUI dependencies automatically? (y/n): "
    
    if /i "!install_choice!"=="y" (
        echo Installing PySide6...
        %python_cmd% -m pip install PySide6
        if %errorlevel% neq 0 (
            echo Installation failed
            echo Please run manually: pip install PySide6
            pause
            exit /b 1
        )
        echo Dependencies installed successfully!
    ) else (
        echo Please install manually: pip install PySide6
        pause
        exit /b 1
    )
)

echo Starting configuration manager...
if exist "claude_config_gui.py" (
    %python_cmd% claude_config_gui.py
) else if exist "start_gui.py" (
    %python_cmd% start_gui.py
) else (
    echo Error: GUI files not found
    echo Please ensure claude_config_gui.py or start_gui.py is in current directory
    pause
    exit /b 1
)
