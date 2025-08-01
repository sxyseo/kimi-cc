@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Claude Code 配置管理器 GUI 启动脚本
:: 自动检查依赖并启动图形界面

echo Claude Code 配置管理器
echo ========================

:: 检查Python
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

echo 错误: 未找到Python
echo 请先安装Python: https://python.org
pause
exit /b 1

:check_gui
echo 正在检查GUI依赖...

:: 检查PySide6
%python_cmd% -c "import PySide6" >nul 2>&1
if %errorlevel% neq 0 (
    echo 未找到PySide6依赖
    set /p "install_choice=是否自动安装GUI依赖? (y/n): "
    
    if /i "!install_choice!"=="y" (
        echo 正在安装PySide6...
        %python_cmd% -m pip install PySide6
        if %errorlevel% neq 0 (
            echo 安装失败，请手动运行: pip install PySide6
            pause
            exit /b 1
        )
        echo 依赖安装成功！
    ) else (
        echo 请手动安装依赖: pip install PySide6
        pause
        exit /b 1
    )
)

:: 启动GUI
echo 正在启动配置管理器...
if exist "claude_config_gui.py" (
    %python_cmd% claude_config_gui.py
) else if exist "start_gui.py" (
    %python_cmd% start_gui.py
) else (
    echo 错误: 未找到GUI文件
    echo 请确保 claude_config_gui.py 或 start_gui.py 在当前目录
    pause
    exit /b 1
)