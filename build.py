#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code 配置管理器 - 跨平台打包脚本
支持Windows、Linux、macOS平台的可执行文件构建
"""

import os
import sys
import shutil
import subprocess
import platform
from pathlib import Path
from datetime import datetime

class Builder:
    def __init__(self):
        self.platform = platform.system().lower()
        self.python_cmd = self.find_python()
        self.project_root = Path.cwd()
        self.dist_dir = self.project_root / "dist"
        self.build_dir = self.project_root / "build"
        self.release_dir = self.project_root / "release"
        
    def find_python(self):
        """查找Python命令"""
        for cmd in ['python3', 'python']:
            try:
                result = subprocess.run([cmd, '--version'], 
                                      capture_output=True, text=True)
                if result.returncode == 0:
                    return cmd
            except FileNotFoundError:
                continue
        raise RuntimeError("未找到Python解释器")
    
    def print_header(self):
        """打印构建头部信息"""
        print("=" * 64)
        print("        Claude Code 配置管理器 - 跨平台打包脚本")
        print("=" * 64)
        print(f"平台: {platform.system()} {platform.machine()}")
        print(f"Python: {self.python_cmd}")
        print("正在构建可执行文件...")
        print()
    
    def check_dependencies(self):
        """检查构建依赖"""
        print("[1/6] 检查构建依赖...")
        
        try:
            import PyInstaller
            print("构建依赖已就绪")
        except ImportError:
            print("未找到PyInstaller，正在安装构建依赖...")
            result = subprocess.run([
                self.python_cmd, '-m', 'pip', 'install', 
                '-r', 'requirements_build.txt'
            ])
            if result.returncode != 0:
                raise RuntimeError("安装构建依赖失败")
            print("构建依赖安装成功！")
    
    def clean_build(self):
        """清理旧的构建文件"""
        print("\n[2/6] 清理旧的构建文件...")
        
        for dir_path in [self.dist_dir, self.build_dir, self.release_dir]:
            if dir_path.exists():
                shutil.rmtree(dir_path)
        
        # 删除spec文件
        for spec_file in self.project_root.glob("*.spec"):
            spec_file.unlink()
        
        print("清理完成")
    
    def build_gui(self):
        """构建GUI可执行文件"""
        print("\n[3/6] 构建GUI可执行文件...")
        
        cmd = [
            self.python_cmd, '-m', 'PyInstaller',
            '--onefile',
            '--windowed',
            '--name', 'Claude-Config-Manager',
            '--add-data', f'example_config.json{os.pathsep}.',
            '--hidden-import', 'PySide6.QtCore',
            '--hidden-import', 'PySide6.QtGui',
            '--hidden-import', 'PySide6.QtWidgets',
            'claude_config_gui.py'
        ]
        
        # Windows平台添加图标
        if self.platform == 'windows':
            icon_path = self.project_root / 'icon.ico'
            if icon_path.exists():
                cmd.extend(['--icon', str(icon_path)])
        
        result = subprocess.run(cmd)
        if result.returncode != 0:
            raise RuntimeError("GUI构建失败")
        
        print("GUI构建成功")
    
    def build_cli_tools(self):
        """构建命令行工具"""
        print("\n[4/6] 构建命令行工具...")
        
        # 构建配置管理器
        cmd1 = [
            self.python_cmd, '-m', 'PyInstaller',
            '--onefile',
            '--console',
            '--name', 'claude-config',
            '--add-data', f'example_config.json{os.pathsep}.',
            'config_manager.py'
        ]
        
        result = subprocess.run(cmd1)
        if result.returncode != 0:
            raise RuntimeError("配置管理器构建失败")
        
        # 构建切换工具
        cmd2 = [
            self.python_cmd, '-m', 'PyInstaller',
            '--onefile',
            '--console',
            '--name', 'claude-switch',
            'switch_provider.py'
        ]
        
        result = subprocess.run(cmd2)
        if result.returncode != 0:
            raise RuntimeError("切换工具构建失败")
        
        print("命令行工具构建成功")
    
    def create_release(self):
        """整理构建结果"""
        print("\n[5/6] 整理构建结果...")
        
        # 创建发布目录
        self.release_dir.mkdir(exist_ok=True)
        
        # 确定可执行文件扩展名
        exe_ext = '.exe' if self.platform == 'windows' else ''
        
        # 复制可执行文件
        executables = [
            f'Claude-Config-Manager{exe_ext}',
            f'claude-config{exe_ext}',
            f'claude-switch{exe_ext}'
        ]
        
        for exe in executables:
            src = self.dist_dir / exe
            dst = self.release_dir / exe
            if src.exists():
                shutil.copy2(src, dst)
                # Unix系统设置执行权限
                if self.platform != 'windows':
                    os.chmod(dst, 0o755)
        
        # 复制配置文件和文档
        files_to_copy = [
            'example_config.json',
            'README.md',
            'QUICK_START.md',
            'IMPORT_EXPORT_GUIDE.md',
            'requirements.txt'
        ]
        
        for file_name in files_to_copy:
            src = self.project_root / file_name
            dst = self.release_dir / file_name
            if src.exists():
                shutil.copy2(src, dst)
        
        # 创建启动脚本
        self.create_startup_scripts()
        
        print("构建结果整理完成")
    
    def create_startup_scripts(self):
        """创建启动脚本"""
        if self.platform == 'windows':
            # Windows批处理脚本
            script_content = """@echo off
cd /d "%~dp0"
Claude-Config-Manager.exe
"""
            script_path = self.release_dir / 'start_gui.bat'
            script_path.write_text(script_content, encoding='utf-8')
        else:
            # Unix Shell脚本
            script_content = """#!/bin/bash
cd "$(dirname "$0")"
./Claude-Config-Manager
"""
            script_path = self.release_dir / 'start_gui.sh'
            script_path.write_text(script_content, encoding='utf-8')
            os.chmod(script_path, 0o755)
    
    def generate_build_info(self):
        """生成构建信息"""
        print("\n[6/6] 生成构建信息...")
        
        # 获取Python版本
        python_version = subprocess.run([self.python_cmd, '--version'], 
                                      capture_output=True, text=True).stdout.strip()
        
        # 获取构建的文件列表
        exe_files = list(self.release_dir.glob('*'))
        exe_files = [f.name for f in exe_files if f.is_file()]
        
        build_info = f"""构建信息
========================================
构建时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
构建平台: {platform.system()} {platform.machine()}
Python版本: {python_version}
PyInstaller版本: {self.get_pyinstaller_version()}

构建的文件:
{chr(10).join(f'  - {f}' for f in sorted(exe_files))}

使用方法:
  GUI界面: 
    Windows: 双击 Claude-Config-Manager.exe 或 start_gui.bat
    Unix/Linux/macOS: 运行 ./Claude-Config-Manager 或 ./start_gui.sh
  
  命令行:
    配置管理: ./claude-config --help
    快速切换: ./claude-switch --help

注意事项:
  - 首次运行可能需要较长时间初始化
  - 如遇到权限问题，请确保文件有执行权限
  - 配置文件保存在用户目录的 .claude_code_config 文件夹中
"""
        
        build_log_path = self.release_dir / 'build.log'
        build_log_path.write_text(build_info, encoding='utf-8')
        
        print("构建信息已保存到 build.log")
    
    def get_pyinstaller_version(self):
        """获取PyInstaller版本"""
        try:
            result = subprocess.run([self.python_cmd, '-c', 
                                   'import PyInstaller; print(PyInstaller.__version__)'],
                                  capture_output=True, text=True)
            return result.stdout.strip()
        except:
            return "未知"
    
    def print_summary(self):
        """打印构建总结"""
        exe_ext = '.exe' if self.platform == 'windows' else ''
        
        print("\n" + "=" * 64)
        print("                        构建完成！")
        print("=" * 64)
        print()
        print(f"可执行文件位置: {self.release_dir}/")
        print(f"  - Claude-Config-Manager{exe_ext}  (GUI界面)")
        print(f"  - claude-config{exe_ext}          (命令行配置管理)")
        print(f"  - claude-switch{exe_ext}          (快速切换工具)")
        
        if self.platform == 'windows':
            print("  - start_gui.bat              (GUI启动脚本)")
        else:
            print("  - start_gui.sh               (GUI启动脚本)")
        
        print()
        print("使用方法:")
        if self.platform == 'windows':
            print("  1. 双击 Claude-Config-Manager.exe 启动GUI")
            print("  2. 或运行 start_gui.bat")
            print("  3. 命令行使用: claude-config.exe --help")
        else:
            print("  1. 运行 ./Claude-Config-Manager 启动GUI")
            print("  2. 或运行 ./start_gui.sh")
            print("  3. 命令行使用: ./claude-config --help")
        
        print()
        print("构建信息已保存到 build.log")
        print("=" * 64)
    
    def build(self):
        """执行完整构建流程"""
        try:
            self.print_header()
            self.check_dependencies()
            self.clean_build()
            self.build_gui()
            self.build_cli_tools()
            self.create_release()
            self.generate_build_info()
            self.print_summary()
            
            print("\n构建成功完成！")
            return True
            
        except Exception as e:
            print(f"\n构建失败: {e}")
            return False

def main():
    """主函数"""
    builder = Builder()
    success = builder.build()
    
    if not success:
        sys.exit(1)
    
    # Windows下暂停等待用户输入
    if platform.system().lower() == 'windows':
        input("\n按回车键退出...")

if __name__ == '__main__':
    main()