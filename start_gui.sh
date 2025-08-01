#!/bin/bash
# Claude Code 配置管理器 GUI 启动脚本
# 自动检查依赖并启动图形界面

echo "Claude Code 配置管理器"
echo "========================"

# 检查Python
if command -v python3 >/dev/null 2>&1; then
    python_cmd="python3"
elif command -v python >/dev/null 2>&1; then
    python_cmd="python"
else
    echo "错误: 未找到Python"
    echo "请先安装Python 3.6或更高版本"
    exit 1
fi

echo "正在检查GUI依赖..."

# 检查PySide6
if ! $python_cmd -c "import PySide6" >/dev/null 2>&1; then
    echo "未找到PySide6依赖"
    read -p "是否自动安装GUI依赖? (y/n): " install_choice
    
    if [[ "$install_choice" =~ ^[Yy]$ ]]; then
        echo "正在安装PySide6..."
        if $python_cmd -m pip install PySide6; then
            echo "依赖安装成功！"
        else
            echo "安装失败，请手动运行: pip install PySide6"
            exit 1
        fi
    else
        echo "请手动安装依赖: pip install PySide6"
        exit 1
    fi
fi

# 启动GUI
echo "正在启动配置管理器..."
if [ -f "claude_config_gui.py" ]; then
    $python_cmd claude_config_gui.py
elif [ -f "start_gui.py" ]; then
    $python_cmd start_gui.py
else
    echo "错误: 未找到GUI文件"
    echo "请确保 claude_config_gui.py 或 start_gui.py 在当前目录"
    exit 1
fi