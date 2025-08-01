@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ================================================================
echo        Claude Code 配置管理器 - Windows 打包脚本
echo ================================================================
echo 正在构建可执行文件...
echo.

:: 检查Python
where python >nul 2>&1
if %errorlevel% equ 0 (
    set "python_cmd=python"
) else (
    where python3 >nul 2>&1
    if %errorlevel% equ 0 (
        set "python_cmd=python3"
    ) else (
        echo 错误: 未找到Python
        echo 请先安装Python: https://python.org
        pause
        exit /b 1
    )
)

echo [1/5] 检查构建依赖...
%python_cmd% -c "import PyInstaller" >nul 2>&1
if %errorlevel% neq 0 (
    echo 未找到PyInstaller，正在安装构建依赖...
    %python_cmd% -m pip install -r requirements_build.txt
    if %errorlevel% neq 0 (
        echo 安装构建依赖失败
        pause
        exit /b 1
    )
    echo 构建依赖安装成功！
) else (
    echo 构建依赖已就绪
)

echo.
echo [2/5] 清理旧的构建文件...
if exist "dist" rmdir /s /q "dist"
if exist "build" rmdir /s /q "build"
if exist "*.spec" del /q "*.spec"
echo 清理完成

echo.
echo [3/5] 构建GUI可执行文件...
%python_cmd% -m PyInstaller ^
    --onefile ^
    --windowed ^
    --name "Claude-Config-Manager" ^
    --icon=icon.ico ^
    --add-data "example_config.json;." ^
    --hidden-import "PySide6.QtCore" ^
    --hidden-import "PySide6.QtGui" ^
    --hidden-import "PySide6.QtWidgets" ^
    claude_config_gui.py

if %errorlevel% neq 0 (
    echo GUI构建失败
    pause
    exit /b 1
)

echo.
echo [4/5] 构建命令行工具...
%python_cmd% -m PyInstaller ^
    --onefile ^
    --console ^
    --name "claude-config" ^
    --add-data "example_config.json;." ^
    config_manager.py

if %errorlevel% neq 0 (
    echo 命令行工具构建失败
    pause
    exit /b 1
)

%python_cmd% -m PyInstaller ^
    --onefile ^
    --console ^
    --name "claude-switch" ^
    switch_provider.py

if %errorlevel% neq 0 (
    echo 切换工具构建失败
    pause
    exit /b 1
)

echo.
echo [5/5] 整理构建结果...
if not exist "release" mkdir "release"

:: 复制可执行文件
copy "dist\Claude-Config-Manager.exe" "release\" >nul
copy "dist\claude-config.exe" "release\" >nul
copy "dist\claude-switch.exe" "release\" >nul

:: 复制配置文件和文档
copy "example_config.json" "release\" >nul
copy "README.md" "release\" >nul
copy "QUICK_START.md" "release\" >nul
copy "IMPORT_EXPORT_GUIDE.md" "release\" >nul

:: 创建启动脚本
echo @echo off > "release\start_gui.bat"
echo cd /d "%%~dp0" >> "release\start_gui.bat"
echo Claude-Config-Manager.exe >> "release\start_gui.bat"

echo.
echo ================================================================
echo                        构建完成！
echo ================================================================
echo.
echo 可执行文件位置: release\
echo   - Claude-Config-Manager.exe  (GUI界面)
echo   - claude-config.exe          (命令行配置管理)
echo   - claude-switch.exe          (快速切换工具)
echo   - start_gui.bat              (GUI启动脚本)
echo.
echo 使用方法:
echo   1. 双击 Claude-Config-Manager.exe 启动GUI
echo   2. 或运行 start_gui.bat
echo   3. 命令行使用: claude-config.exe --help
echo.
echo 构建信息已保存到 build.log
echo ================================================================

:: 生成构建信息
echo 构建时间: %date% %time% > "release\build.log"
echo Python版本: >> "release\build.log"
%python_cmd% --version >> "release\build.log"
echo. >> "release\build.log"
echo 构建的文件: >> "release\build.log"
dir "release\*.exe" /b >> "release\build.log"

pause