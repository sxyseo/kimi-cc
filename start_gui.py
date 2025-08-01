#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code 配置管理器启动脚本
检查依赖并启动GUI界面
"""

import sys
import subprocess
import os

def check_dependencies():
    """检查依赖"""
    try:
        import PySide6
        return True
    except ImportError:
        return False

def install_dependencies():
    """安装依赖"""
    print("正在安装GUI依赖...")
    try:
        subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'PySide6'])
        return True
    except subprocess.CalledProcessError:
        return False

def main():
    """主函数"""
    print("Claude Code 配置管理器")
    print("=" * 30)
    
    # 检查依赖
    if not check_dependencies():
        print("未找到PySide6依赖")
        
        choice = input("是否自动安装? (y/n): ").lower().strip()
        if choice in ['y', 'yes', '是']:
            if install_dependencies():
                print("✓ 依赖安装成功")
            else:
                print("✗ 依赖安装失败")
                print("请手动运行: pip install PySide6")
                return
        else:
            print("请手动安装依赖: pip install PySide6")
            return
    
    # 启动GUI
    try:
        from claude_config_gui import main as gui_main
        print("正在启动GUI界面...")
        gui_main()
    except Exception as e:
        print(f"启动GUI失败: {e}")
        print("请确保所有文件都在同一目录下")

if __name__ == '__main__':
    main()