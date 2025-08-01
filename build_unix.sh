#!/bin/bash
# -*- coding: utf-8 -*-

echo "================================================================"
echo "        Claude Code 配置管理器 - Unix/Linux/macOS 打包脚本"
echo "================================================================"
echo "正在构建可执行文件..."
echo

# 检查Python
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "错误: 未找到Python"
    echo "请先安装Python: https://python.org"
    exit 1
fi

echo "[1/5] 检查构建依赖..."
$PYTHON_CMD -c "import PyInstaller" &> /dev/null
if [ $? -ne 0 ]; then
    echo "未找到PyInstaller，正在安装构建依赖..."
    $PYTHON_CMD -m pip install -r requirements_build.txt
    if [ $? -ne 0 ]; then
        echo "安装构建依赖失败"
        exit 1
    fi
    echo "构建依赖安装成功！"
else
    echo "构建依赖已就绪"
fi

echo
echo "[2/5] 清理旧的构建文件..."
rm -rf dist build *.spec
echo "清理完成"

echo
echo "[3/5] 构建GUI可执行文件..."
$PYTHON_CMD -m PyInstaller \
    --onefile \
    --windowed \
    --name "Claude-Config-Manager" \
    --add-data "example_config.json:." \
    --hidden-import "PySide6.QtCore" \
    --hidden-import "PySide6.QtGui" \
    --hidden-import "PySide6.QtWidgets" \
    claude_config_gui.py

if [ $? -ne 0 ]; then
    echo "GUI构建失败"
    exit 1
fi

echo
echo "[4/5] 构建命令行工具..."
$PYTHON_CMD -m PyInstaller \
    --onefile \
    --console \
    --name "claude-config" \
    --add-data "example_config.json:." \
    config_manager.py

if [ $? -ne 0 ]; then
    echo "命令行工具构建失败"
    exit 1
fi

$PYTHON_CMD -m PyInstaller \
    --onefile \
    --console \
    --name "claude-switch" \
    switch_provider.py

if [ $? -ne 0 ]; then
    echo "切换工具构建失败"
    exit 1
fi

echo
echo "[5/5] 整理构建结果..."
mkdir -p release

# 复制可执行文件
cp dist/Claude-Config-Manager release/
cp dist/claude-config release/
cp dist/claude-switch release/

# 设置执行权限
chmod +x release/Claude-Config-Manager
chmod +x release/claude-config
chmod +x release/claude-switch

# 复制配置文件和文档
cp example_config.json release/
cp README.md release/
cp QUICK_START.md release/
cp IMPORT_EXPORT_GUIDE.md release/

# 创建启动脚本
cat > release/start_gui.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"
./Claude-Config-Manager
EOF

chmod +x release/start_gui.sh

echo
echo "================================================================"
echo "                        构建完成！"
echo "================================================================"
echo
echo "可执行文件位置: release/"
echo "  - Claude-Config-Manager  (GUI界面)"
echo "  - claude-config          (命令行配置管理)"
echo "  - claude-switch          (快速切换工具)"
echo "  - start_gui.sh           (GUI启动脚本)"
echo
echo "使用方法:"
echo "  1. 运行 ./Claude-Config-Manager 启动GUI"
echo "  2. 或运行 ./start_gui.sh"
echo "  3. 命令行使用: ./claude-config --help"
echo
echo "构建信息已保存到 build.log"
echo "================================================================"

# 生成构建信息
{
    echo "构建时间: $(date)"
    echo "Python版本:"
    $PYTHON_CMD --version
    echo
    echo "构建的文件:"
    ls -la release/
} > release/build.log

echo "构建完成！按任意键继续..."
read -n 1