#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code 提供商快速切换脚本
支持命令行快速切换AI提供商
"""

import sys
import os
from config_manager import ConfigManager

def main():
    """主函数"""
    config_manager = ConfigManager()
    
    if len(sys.argv) < 2:
        # 显示可用提供商
        print("Claude Code 提供商快速切换")
        print("=" * 40)
        
        providers = config_manager.list_providers()
        current = config_manager.get_current_provider()
        
        print("可用提供商:")
        for provider_id, info in providers.items():
            if info['is_configured']:
                status = "✓ 当前" if info['is_current'] else "○ 可用"
                print(f"  {status} {provider_id}: {info['name']}")
        
        print("\n使用方法:")
        print(f"  python {sys.argv[0]} <provider_id>")
        print("\n示例:")
        print(f"  python {sys.argv[0]} qwen     # 切换到通义千问")
        print(f"  python {sys.argv[0]} kimi     # 切换到Kimi")
        print(f"  python {sys.argv[0]} zhipu    # 切换到智谱GLM-4.5")
        return
    
    provider_id = sys.argv[1].lower()
    
    # 尝试切换
    if config_manager.switch_provider(provider_id):
        providers = config_manager.load_providers()
        if provider_id in providers['providers']:
            provider_name = providers['providers'][provider_id]['name']
            print(f"✓ 已成功切换到: {provider_name}")
            
            # 显示当前环境变量
            env_info = config_manager.get_current_env_info()
            print(f"  Base URL: {env_info['base_url']}")
            print(f"  API Key: {'已设置' if env_info['api_key'] else '未设置'}")
        else:
            print(f"✓ 已切换到: {provider_id}")
    else:
        print(f"✗ 切换失败: 提供商 '{provider_id}' 不存在或未配置")
        print("\n请先使用GUI界面或命令行工具配置提供商:")
        print("  python config_manager.py list")

if __name__ == '__main__':
    main()