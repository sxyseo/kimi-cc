#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code 配置管理器 - 简化构建脚本
快速构建核心可执行文件
"""

import os
import sys
import subprocess
import shutil
from pathlib import Path

def run_command(cmd, description):
    """运行命令并处理错误"""
    print(f"正在{description}...")
    try:
        result = subprocess.run(cmd, shell=True, check=True, 
                              capture_output=True, text=True)
        print(f"✓ {description}成功")
        return True
    except subprocess.CalledProcessError as e:
        print(f"✗ {description}失败: {e}")
        if e.stdout:
            print("标准输出:", e.stdout)
        if e.stderr:
            print("错误输出:", e.stderr)
        return False

def main():
    print("Claude Code 配置管理器 - 简化构建")
    print("=" * 50)
    
    # 检查PyInstaller
    if not run_command("python -c \"import PyInstaller\"", "检查PyInstaller"):
        print("正在安装PyInstaller...")
        if not run_command("pip install pyinstaller", "安装PyInstaller"):
            return False
    
    # 清理旧文件
    for dir_name in ['dist', 'build']:
        if os.path.exists(dir_name):
            shutil.rmtree(dir_name)
            print(f"✓ 清理 {dir_name} 目录")
    
    # 构建GUI
    gui_cmd = """python -m PyInstaller --onefile --windowed --name "Claude-Config-Manager" claude_config_gui.py"""
    if not run_command(gui_cmd, "构建GUI应用"):
        return False
    
    # 构建CLI工具
    cli_cmd = """python -m PyInstaller --onefile --console --name "claude-config" config_manager.py"""
    if not run_command(cli_cmd, "构建CLI工具"):
        return False
    
    # 构建切换工具
    switch_cmd = """python -m PyInstaller --onefile --console --name "claude-switch" switch_provider.py"""
    if not run_command(switch_cmd, "构建切换工具"):
        return False
    
    # 创建发布目录
    release_dir = Path("release_simple")
    if release_dir.exists():
        shutil.rmtree(release_dir)
    release_dir.mkdir()
    
    # 复制可执行文件
    dist_dir = Path("dist")
    exe_files = list(dist_dir.glob("*.exe"))
    
    for exe_file in exe_files:
        shutil.copy2(exe_file, release_dir)
        print(f"✓ 复制 {exe_file.name}")
    
    # 复制重要文件
    important_files = [
        "README.md",
        "QUICK_START.md", 
        "example_config.json"
    ]
    
    for file_name in important_files:
        if os.path.exists(file_name):
            shutil.copy2(file_name, release_dir)
            print(f"✓ 复制 {file_name}")
    
    # 创建启动脚本
    start_script = release_dir / "start_gui.bat"
    start_script.write_text("""@echo off
cd /d "%~dp0"
Claude-Config-Manager.exe
pause
""", encoding='utf-8')
    print("✓ 创建启动脚本")
    
    print("\n" + "=" * 50)
    print("构建完成！")
    print(f"可执行文件位置: {release_dir}/")
    print("- Claude-Config-Manager.exe (GUI)")
    print("- claude-config.exe (CLI)")
    print("- claude-switch.exe (切换工具)")
    print("- start_gui.bat (启动脚本)")
    print("=" * 50)
    
    return True

if __name__ == "__main__":
    success = main()
    if not success:
        print("构建失败！")
        sys.exit(1)
    
    input("按回车键退出...")