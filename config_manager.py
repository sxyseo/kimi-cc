#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code 配置管理器
支持多个AI提供商的配置管理和快速切换
"""

import json
import os
import sys
import subprocess
from pathlib import Path
from typing import Dict, List, Optional

class ConfigManager:
    def __init__(self):
        self.config_dir = Path.home() / ".claude_code_config"
        self.config_file = self.config_dir / "providers.json"
        self.current_config_file = self.config_dir / "current.json"
        self.ensure_config_dir()
        
    def ensure_config_dir(self):
        """确保配置目录存在"""
        self.config_dir.mkdir(exist_ok=True)
        
    def load_providers(self) -> Dict:
        """加载所有提供商配置"""
        if not self.config_file.exists():
            return self.get_default_providers()
        
        try:
            with open(self.config_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            return self.get_default_providers()
    
    def get_default_providers(self) -> Dict:
        """获取默认提供商配置"""
        return {
            "providers": {
                "qwen": {
                    "name": "阿里云通义千问",
                    "base_url": "https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy",
                    "api_key": "",
                    "description": "阿里云通义千问系列模型"
                },
                "kimi": {
                    "name": "Kimi (月之暗面)",
                    "base_url": "https://api.moonshot.cn/anthropic/",
                    "api_key": "",
                    "description": "月之暗面 Kimi 模型"
                },
                "zhipu": {
                    "name": "智谱 GLM-4.5",
                    "base_url": "https://open.bigmodel.cn/api/anthropic",
                    "api_key": "",
                    "description": "智谱 AI GLM-4.5 模型"
                },
                "custom": {
                    "name": "自定义提供商",
                    "base_url": "",
                    "api_key": "",
                    "description": "自定义 API 提供商"
                }
            }
        }
    
    def save_providers(self, providers: Dict):
        """保存提供商配置"""
        with open(self.config_file, 'w', encoding='utf-8') as f:
            json.dump(providers, f, ensure_ascii=False, indent=2)
    
    def get_current_provider(self) -> Optional[str]:
        """获取当前激活的提供商"""
        if not self.current_config_file.exists():
            return None
            
        try:
            with open(self.current_config_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return data.get('current_provider')
        except (json.JSONDecodeError, FileNotFoundError):
            return None
    
    def set_current_provider(self, provider_id: str):
        """设置当前激活的提供商"""
        data = {'current_provider': provider_id}
        with open(self.current_config_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
    
    def add_provider(self, provider_id: str, name: str, base_url: str, api_key: str, description: str = ""):
        """添加新的提供商配置"""
        providers = self.load_providers()
        providers['providers'][provider_id] = {
            'name': name,
            'base_url': base_url,
            'api_key': api_key,
            'description': description
        }
        self.save_providers(providers)
    
    def update_provider(self, provider_id: str, **kwargs):
        """更新提供商配置"""
        providers = self.load_providers()
        if provider_id in providers['providers']:
            providers['providers'][provider_id].update(kwargs)
            self.save_providers(providers)
            return True
        return False
    
    def delete_provider(self, provider_id: str):
        """删除提供商配置"""
        providers = self.load_providers()
        if provider_id in providers['providers']:
            del providers['providers'][provider_id]
            self.save_providers(providers)
            
            # 如果删除的是当前提供商，清除当前设置
            if self.get_current_provider() == provider_id:
                self.set_current_provider("")
            return True
        return False
    
    def switch_provider(self, provider_id: str) -> bool:
        """切换到指定提供商"""
        providers = self.load_providers()
        if provider_id not in providers['providers']:
            return False
            
        provider = providers['providers'][provider_id]
        if not provider['api_key'] or not provider['base_url']:
            return False
        
        # 设置环境变量
        self.set_environment_variables(provider['base_url'], provider['api_key'])
        
        # 保存当前提供商
        self.set_current_provider(provider_id)
        
        return True
    
    def set_environment_variables(self, base_url: str, api_key: str):
        """设置环境变量"""
        if sys.platform == "win32":
            self._set_windows_env(base_url, api_key)
        else:
            self._set_unix_env(base_url, api_key)
    
    def _set_windows_env(self, base_url: str, api_key: str):
        """设置Windows环境变量"""
        try:
            # 设置用户环境变量（永久）
            subprocess.run(['setx', 'ANTHROPIC_BASE_URL', base_url], check=True, capture_output=True)
            subprocess.run(['setx', 'ANTHROPIC_AUTH_TOKEN', api_key], check=True, capture_output=True)
            
            # 设置当前会话环境变量
            os.environ['ANTHROPIC_BASE_URL'] = base_url
            os.environ['ANTHROPIC_AUTH_TOKEN'] = api_key
            
        except subprocess.CalledProcessError as e:
            print(f"设置Windows环境变量失败: {e}")
    
    def _set_unix_env(self, base_url: str, api_key: str):
        """设置Unix/Linux/macOS环境变量"""
        # 设置当前会话环境变量
        os.environ['ANTHROPIC_BASE_URL'] = base_url
        os.environ['ANTHROPIC_AUTH_TOKEN'] = api_key
        
        # 更新shell配置文件
        shell = os.environ.get('SHELL', '/bin/bash')
        if 'zsh' in shell:
            rc_file = Path.home() / '.zshrc'
        elif 'fish' in shell:
            rc_file = Path.home() / '.config' / 'fish' / 'config.fish'
        else:
            rc_file = Path.home() / '.bashrc'
        
        self._update_shell_config(rc_file, base_url, api_key)
    
    def _update_shell_config(self, rc_file: Path, base_url: str, api_key: str):
        """更新shell配置文件"""
        try:
            # 读取现有内容
            content = ""
            if rc_file.exists():
                with open(rc_file, 'r', encoding='utf-8') as f:
                    content = f.read()
            
            # 移除旧的Claude Code配置
            lines = content.split('\n')
            new_lines = []
            skip_next = False
            
            for line in lines:
                if '# Claude Code environment variables' in line:
                    skip_next = True
                    continue
                elif skip_next and (line.startswith('export ANTHROPIC_') or line.strip() == ''):
                    if not line.startswith('export ANTHROPIC_'):
                        skip_next = False
                        new_lines.append(line)
                    continue
                else:
                    skip_next = False
                    new_lines.append(line)
            
            # 添加新的配置
            new_lines.extend([
                '',
                '# Claude Code environment variables',
                f'export ANTHROPIC_BASE_URL={base_url}',
                f'export ANTHROPIC_AUTH_TOKEN={api_key}'
            ])
            
            # 写入文件
            rc_file.parent.mkdir(parents=True, exist_ok=True)
            with open(rc_file, 'w', encoding='utf-8') as f:
                f.write('\n'.join(new_lines))
                
        except Exception as e:
            print(f"更新shell配置文件失败: {e}")
    
    def get_current_env_info(self) -> Dict:
        """获取当前环境变量信息"""
        return {
            'base_url': os.environ.get('ANTHROPIC_BASE_URL', ''),
            'api_key': os.environ.get('ANTHROPIC_AUTH_TOKEN', ''),
            'current_provider': self.get_current_provider()
        }
    
    def list_providers(self) -> Dict:
        """列出所有提供商"""
        providers = self.load_providers()
        current = self.get_current_provider()
        
        result = {}
        for provider_id, provider_info in providers['providers'].items():
            result[provider_id] = {
                **provider_info,
                'is_current': provider_id == current,
                'is_configured': bool(provider_info.get('api_key'))
            }
        
        return result

def main():
    """命令行接口"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Claude Code 配置管理器')
    subparsers = parser.add_subparsers(dest='command', help='可用命令')
    
    # 列出提供商
    list_parser = subparsers.add_parser('list', help='列出所有提供商')
    
    # 切换提供商
    switch_parser = subparsers.add_parser('switch', help='切换提供商')
    switch_parser.add_argument('provider', help='提供商ID')
    
    # 添加提供商
    add_parser = subparsers.add_parser('add', help='添加提供商')
    add_parser.add_argument('id', help='提供商ID')
    add_parser.add_argument('name', help='提供商名称')
    add_parser.add_argument('base_url', help='Base URL')
    add_parser.add_argument('api_key', help='API Key')
    add_parser.add_argument('--description', help='描述', default='')
    
    # 更新提供商
    update_parser = subparsers.add_parser('update', help='更新提供商')
    update_parser.add_argument('id', help='提供商ID')
    update_parser.add_argument('--name', help='提供商名称')
    update_parser.add_argument('--base_url', help='Base URL')
    update_parser.add_argument('--api_key', help='API Key')
    update_parser.add_argument('--description', help='描述')
    
    # 删除提供商
    delete_parser = subparsers.add_parser('delete', help='删除提供商')
    delete_parser.add_argument('id', help='提供商ID')
    
    # 显示当前状态
    status_parser = subparsers.add_parser('status', help='显示当前状态')
    
    # 导出配置
    export_parser = subparsers.add_parser('export', help='导出配置')
    export_parser.add_argument('file', help='导出文件路径')
    export_parser.add_argument('--include-keys', action='store_true', help='包含API Keys')
    
    # 导入配置
    import_parser = subparsers.add_parser('import', help='导入配置')
    import_parser.add_argument('file', help='导入文件路径')
    import_parser.add_argument('--merge', action='store_true', help='合并模式（保留现有配置）')
    import_parser.add_argument('--force', action='store_true', help='强制覆盖冲突的提供商')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        return
    
    config_manager = ConfigManager()
    
    if args.command == 'list':
        providers = config_manager.list_providers()
        print("可用的提供商:")
        for provider_id, info in providers.items():
            status = "✓ 当前" if info['is_current'] else ("○ 已配置" if info['is_configured'] else "× 未配置")
            print(f"  {status} {provider_id}: {info['name']}")
            if info.get('description'):
                print(f"    {info['description']}")
    
    elif args.command == 'switch':
        if config_manager.switch_provider(args.provider):
            providers = config_manager.load_providers()
            provider_name = providers['providers'][args.provider]['name']
            print(f"✓ 已切换到: {provider_name}")
        else:
            print(f"✗ 切换失败: 提供商 '{args.provider}' 不存在或未配置")
    
    elif args.command == 'add':
        config_manager.add_provider(args.id, args.name, args.base_url, args.api_key, args.description)
        print(f"✓ 已添加提供商: {args.name}")
    
    elif args.command == 'update':
        kwargs = {}
        if args.name: kwargs['name'] = args.name
        if args.base_url: kwargs['base_url'] = args.base_url
        if args.api_key: kwargs['api_key'] = args.api_key
        if args.description: kwargs['description'] = args.description
        
        if config_manager.update_provider(args.id, **kwargs):
            print(f"✓ 已更新提供商: {args.id}")
        else:
            print(f"✗ 更新失败: 提供商 '{args.id}' 不存在")
    
    elif args.command == 'delete':
        if config_manager.delete_provider(args.id):
            print(f"✓ 已删除提供商: {args.id}")
        else:
            print(f"✗ 删除失败: 提供商 '{args.id}' 不存在")
    
    elif args.command == 'status':
        env_info = config_manager.get_current_env_info()
        providers = config_manager.load_providers()
        
        print("当前状态:")
        if env_info['current_provider']:
            provider_name = providers['providers'][env_info['current_provider']]['name']
            print(f"  当前提供商: {provider_name} ({env_info['current_provider']})")
        else:
            print("  当前提供商: 未设置")
        
        print(f"  Base URL: {env_info['base_url'] or '未设置'}")
        print(f"  API Key: {'已设置' if env_info['api_key'] else '未设置'}")
    
    elif args.command == 'export':
        import json
        from datetime import datetime
        
        try:
            # 获取当前配置
            config = config_manager.load_providers()
            
            if not config.get('providers'):
                print("✗ 没有可导出的配置")
                return
            
            # 准备导出数据
            export_data = {
                "export_info": {
                    "version": "1.0.0",
                    "export_time": datetime.now().isoformat(),
                    "total_providers": len(config['providers'])
                },
                "providers": {}
            }
            
            # 处理每个提供商配置
            for provider_id, provider_info in config['providers'].items():
                export_provider = provider_info.copy()
                
                if not args.include_keys:
                    # 移除敏感信息
                    export_provider['api_key'] = ""
                
                export_data['providers'][provider_id] = export_provider
            
            # 写入文件
            with open(args.file, 'w', encoding='utf-8') as f:
                json.dump(export_data, f, ensure_ascii=False, indent=2)
            
            provider_count = len(export_data['providers'])
            keys_info = "包含API Keys" if args.include_keys else "不包含API Keys"
            
            print(f"✓ 成功导出 {provider_count} 个提供商配置")
            print(f"✓ 文件位置: {args.file}")
            print(f"✓ 导出选项: {keys_info}")
            
        except Exception as e:
            print(f"✗ 导出失败: {str(e)}")
    
    elif args.command == 'import':
        import json
        
        try:
            # 读取配置文件
            with open(args.file, 'r', encoding='utf-8') as f:
                imported_config = json.load(f)
            
            # 验证配置文件格式
            if 'providers' not in imported_config:
                print("✗ 配置文件格式不正确，缺少 'providers' 字段")
                return
            
            # 获取当前配置
            current_config = config_manager.load_providers()
            
            if args.merge:
                # 合并模式：保留现有配置
                new_config = current_config.copy()
                imported_count = 0
                
                for provider_id, provider_info in imported_config['providers'].items():
                    if provider_id in new_config['providers']:
                        if args.force:
                            # 强制覆盖
                            new_config['providers'][provider_id] = provider_info
                            imported_count += 1
                            print(f"✓ 覆盖提供商: {provider_info.get('name', provider_id)}")
                        else:
                            print(f"○ 跳过已存在的提供商: {provider_info.get('name', provider_id)}")
                    else:
                        new_config['providers'][provider_id] = provider_info
                        imported_count += 1
                        print(f"✓ 添加提供商: {provider_info.get('name', provider_id)}")
            else:
                # 替换模式：清空现有配置
                new_config = imported_config
                imported_count = len(imported_config['providers'])
                print("⚠️  替换模式：清空现有配置")
            
            # 保存新配置
            config_manager.save_providers(new_config)
            
            print(f"✓ 成功导入 {imported_count} 个提供商配置")
            
        except json.JSONDecodeError:
            print("✗ 配置文件格式错误，请检查JSON格式")
        except FileNotFoundError:
            print(f"✗ 文件不存在: {args.file}")
        except Exception as e:
            print(f"✗ 导入失败: {str(e)}")

if __name__ == '__main__':
    main()