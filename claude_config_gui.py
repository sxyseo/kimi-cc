#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code 配置管理器 GUI
使用 PySide6 开发的图形界面，方便快速切换AI提供商
"""

import sys
import os
from pathlib import Path
from typing import Dict, Optional

try:
    from PySide6.QtWidgets import (
        QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
        QLabel, QLineEdit, QPushButton, QComboBox, QTextEdit, QGroupBox,
        QFormLayout, QMessageBox, QTabWidget, QTableWidget, QTableWidgetItem,
        QHeaderView, QSplitter, QFrame, QStatusBar, QToolBar, QDialog,
        QDialogButtonBox, QCheckBox
    )
    from PySide6.QtCore import Qt, QTimer, Signal, QThread
    from PySide6.QtGui import QIcon, QFont, QPixmap, QAction
except ImportError:
    print("错误: 未安装 PySide6")
    print("请运行: pip install PySide6")
    sys.exit(1)

from config_manager import ConfigManager

class ProviderDialog(QDialog):
    """添加/编辑提供商对话框"""
    
    def __init__(self, parent=None, provider_data=None, provider_id=None):
        super().__init__(parent)
        self.provider_data = provider_data or {}
        self.provider_id = provider_id
        self.setup_ui()
        self.load_data()
        
    def setup_ui(self):
        self.setWindowTitle("添加提供商" if not self.provider_id else "编辑提供商")
        self.setModal(True)
        self.resize(400, 300)
        
        layout = QVBoxLayout(self)
        
        # 表单
        form_layout = QFormLayout()
        
        self.id_edit = QLineEdit()
        self.id_edit.setEnabled(not self.provider_id)  # 编辑时不允许修改ID
        form_layout.addRow("提供商ID:", self.id_edit)
        
        self.name_edit = QLineEdit()
        form_layout.addRow("名称:", self.name_edit)
        
        self.base_url_edit = QLineEdit()
        form_layout.addRow("Base URL:", self.base_url_edit)
        
        self.api_key_edit = QLineEdit()
        self.api_key_edit.setEchoMode(QLineEdit.Password)
        form_layout.addRow("API Key:", self.api_key_edit)
        
        self.description_edit = QTextEdit()
        self.description_edit.setMaximumHeight(80)
        form_layout.addRow("描述:", self.description_edit)
        
        layout.addLayout(form_layout)
        
        # 按钮
        button_box = QDialogButtonBox(QDialogButtonBox.Ok | QDialogButtonBox.Cancel)
        button_box.accepted.connect(self.accept)
        button_box.rejected.connect(self.reject)
        layout.addWidget(button_box)
        
    def load_data(self):
        """加载数据到表单"""
        if self.provider_data:
            self.id_edit.setText(self.provider_id or "")
            self.name_edit.setText(self.provider_data.get('name', ''))
            self.base_url_edit.setText(self.provider_data.get('base_url', ''))
            self.api_key_edit.setText(self.provider_data.get('api_key', ''))
            self.description_edit.setPlainText(self.provider_data.get('description', ''))
    
    def get_data(self):
        """获取表单数据"""
        return {
            'id': self.id_edit.text().strip(),
            'name': self.name_edit.text().strip(),
            'base_url': self.base_url_edit.text().strip(),
            'api_key': self.api_key_edit.text().strip(),
            'description': self.description_edit.toPlainText().strip()
        }
    
    def accept(self):
        """验证并接受"""
        data = self.get_data()
        
        if not data['id']:
            QMessageBox.warning(self, "错误", "请输入提供商ID")
            return
            
        if not data['name']:
            QMessageBox.warning(self, "错误", "请输入提供商名称")
            return
            
        if not data['base_url']:
            QMessageBox.warning(self, "错误", "请输入Base URL")
            return
            
        if not data['api_key']:
            QMessageBox.warning(self, "错误", "请输入API Key")
            return
        
        super().accept()

class StatusUpdateThread(QThread):
    """状态更新线程"""
    status_updated = Signal(dict)
    
    def __init__(self, config_manager):
        super().__init__()
        self.config_manager = config_manager
        self.running = True
        
    def run(self):
        while self.running:
            try:
                env_info = self.config_manager.get_current_env_info()
                self.status_updated.emit(env_info)
            except Exception as e:
                print(f"状态更新错误: {e}")
            
            self.msleep(2000)  # 每2秒更新一次
    
    def stop(self):
        self.running = False
        self.quit()
        self.wait()

class ClaudeConfigGUI(QMainWindow):
    """主窗口"""
    
    def __init__(self):
        super().__init__()
        self.config_manager = ConfigManager()
        self.status_thread = None
        self.setup_ui()
        self.setup_status_bar()
        self.setup_toolbar()
        self.load_providers()
        self.start_status_updates()
        
    def setup_ui(self):
        """设置UI"""
        self.setWindowTitle("Claude Code 配置管理器")
        self.setGeometry(100, 100, 800, 600)
        
        # 中央部件
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        
        # 主布局
        main_layout = QHBoxLayout(central_widget)
        
        # 分割器
        splitter = QSplitter(Qt.Horizontal)
        main_layout.addWidget(splitter)
        
        # 左侧面板 - 提供商列表
        left_panel = self.create_providers_panel()
        splitter.addWidget(left_panel)
        
        # 右侧面板 - 详细信息和控制
        right_panel = self.create_control_panel()
        splitter.addWidget(right_panel)
        
        # 设置分割器比例
        splitter.setSizes([300, 500])
        
    def create_providers_panel(self):
        """创建提供商列表面板"""
        panel = QGroupBox("提供商列表")
        layout = QVBoxLayout(panel)
        
        # 提供商表格
        self.providers_table = QTableWidget()
        self.providers_table.setColumnCount(3)
        self.providers_table.setHorizontalHeaderLabels(["状态", "名称", "描述"])
        
        # 设置表格属性
        header = self.providers_table.horizontalHeader()
        header.setSectionResizeMode(0, QHeaderView.ResizeToContents)
        header.setSectionResizeMode(1, QHeaderView.Stretch)
        header.setSectionResizeMode(2, QHeaderView.Stretch)
        
        self.providers_table.setSelectionBehavior(QTableWidget.SelectRows)
        self.providers_table.itemSelectionChanged.connect(self.on_provider_selected)
        
        layout.addWidget(self.providers_table)
        
        # 按钮布局
        button_layout = QHBoxLayout()
        
        self.add_btn = QPushButton("添加")
        self.add_btn.clicked.connect(self.add_provider)
        button_layout.addWidget(self.add_btn)
        
        self.edit_btn = QPushButton("编辑")
        self.edit_btn.clicked.connect(self.edit_provider)
        self.edit_btn.setEnabled(False)
        button_layout.addWidget(self.edit_btn)
        
        self.delete_btn = QPushButton("删除")
        self.delete_btn.clicked.connect(self.delete_provider)
        self.delete_btn.setEnabled(False)
        button_layout.addWidget(self.delete_btn)
        
        layout.addLayout(button_layout)
        
        return panel
    
    def create_control_panel(self):
        """创建控制面板"""
        panel = QWidget()
        layout = QVBoxLayout(panel)
        
        # 当前状态组
        status_group = QGroupBox("当前状态")
        status_layout = QFormLayout(status_group)
        
        self.current_provider_label = QLabel("未设置")
        self.current_provider_label.setStyleSheet("font-weight: bold; color: #2196F3;")
        status_layout.addRow("当前提供商:", self.current_provider_label)
        
        self.current_base_url_label = QLabel("未设置")
        status_layout.addRow("Base URL:", self.current_base_url_label)
        
        self.current_api_key_label = QLabel("未设置")
        status_layout.addRow("API Key:", self.current_api_key_label)
        
        layout.addWidget(status_group)
        
        # 快速切换组
        switch_group = QGroupBox("快速切换")
        switch_layout = QVBoxLayout(switch_group)
        
        switch_form = QHBoxLayout()
        switch_form.addWidget(QLabel("选择提供商:"))
        
        self.provider_combo = QComboBox()
        self.provider_combo.currentTextChanged.connect(self.on_combo_changed)
        switch_form.addWidget(self.provider_combo)
        
        self.switch_btn = QPushButton("切换")
        self.switch_btn.clicked.connect(self.switch_provider)
        self.switch_btn.setEnabled(False)
        switch_form.addWidget(self.switch_btn)
        
        switch_layout.addLayout(switch_form)
        layout.addWidget(switch_group)
        
        # 提供商详情组
        details_group = QGroupBox("提供商详情")
        details_layout = QFormLayout(details_group)
        
        self.detail_name_label = QLabel("-")
        details_layout.addRow("名称:", self.detail_name_label)
        
        self.detail_base_url_label = QLabel("-")
        self.detail_base_url_label.setWordWrap(True)
        details_layout.addRow("Base URL:", self.detail_base_url_label)
        
        self.detail_api_key_label = QLabel("-")
        details_layout.addRow("API Key:", self.detail_api_key_label)
        
        self.detail_description_label = QLabel("-")
        self.detail_description_label.setWordWrap(True)
        details_layout.addRow("描述:", self.detail_description_label)
        
        layout.addWidget(details_group)
        
        # 操作日志
        log_group = QGroupBox("操作日志")
        log_layout = QVBoxLayout(log_group)
        
        self.log_text = QTextEdit()
        self.log_text.setMaximumHeight(150)
        self.log_text.setReadOnly(True)
        log_layout.addWidget(self.log_text)
        
        layout.addWidget(log_group)
        
        # 添加弹性空间
        layout.addStretch()
        
        return panel
    
    def setup_status_bar(self):
        """设置状态栏"""
        self.status_bar = QStatusBar()
        self.setStatusBar(self.status_bar)
        self.status_bar.showMessage("就绪")
    
    def setup_toolbar(self):
        """设置工具栏"""
        toolbar = QToolBar()
        self.addToolBar(toolbar)
        
        # 刷新动作
        refresh_action = QAction("刷新", self)
        refresh_action.triggered.connect(self.refresh_data)
        toolbar.addAction(refresh_action)
        
        toolbar.addSeparator()
        
        # 导入配置动作
        import_action = QAction("导入配置", self)
        import_action.triggered.connect(self.import_config)
        toolbar.addAction(import_action)
        
        # 导出配置动作
        export_action = QAction("导出配置", self)
        export_action.triggered.connect(self.export_config)
        toolbar.addAction(export_action)
        
        toolbar.addSeparator()
        
        # 关于动作
        about_action = QAction("关于", self)
        about_action.triggered.connect(self.show_about)
        toolbar.addAction(about_action)
    
    def start_status_updates(self):
        """启动状态更新线程"""
        self.status_thread = StatusUpdateThread(self.config_manager)
        self.status_thread.status_updated.connect(self.update_status_display)
        self.status_thread.start()
    
    def load_providers(self):
        """加载提供商列表"""
        providers = self.config_manager.list_providers()
        
        # 更新表格
        self.providers_table.setRowCount(len(providers))
        
        for row, (provider_id, info) in enumerate(providers.items()):
            # 状态列
            if info['is_current']:
                status = "✓ 当前"
                status_color = "#4CAF50"
            elif info['is_configured']:
                status = "○ 已配置"
                status_color = "#2196F3"
            else:
                status = "× 未配置"
                status_color = "#F44336"
            
            status_item = QTableWidgetItem(status)
            from PySide6.QtGui import QColor
            status_item.setForeground(QColor(status_color))
            status_item.setData(Qt.UserRole, provider_id)
            self.providers_table.setItem(row, 0, status_item)
            
            # 名称列
            name_item = QTableWidgetItem(info['name'])
            self.providers_table.setItem(row, 1, name_item)
            
            # 描述列
            desc_item = QTableWidgetItem(info.get('description', ''))
            self.providers_table.setItem(row, 2, desc_item)
        
        # 更新下拉框
        self.provider_combo.clear()
        configured_providers = {pid: info for pid, info in providers.items() if info['is_configured']}
        
        for provider_id, info in configured_providers.items():
            display_text = f"{info['name']} ({provider_id})"
            self.provider_combo.addItem(display_text, provider_id)
        
        # 选中当前提供商
        current_provider = self.config_manager.get_current_provider()
        if current_provider:
            for i in range(self.provider_combo.count()):
                if self.provider_combo.itemData(i) == current_provider:
                    self.provider_combo.setCurrentIndex(i)
                    break
    
    def on_provider_selected(self):
        """提供商选择变化"""
        selected_rows = self.providers_table.selectionModel().selectedRows()
        
        if selected_rows:
            row = selected_rows[0].row()
            provider_id = self.providers_table.item(row, 0).data(Qt.UserRole)
            
            # 启用编辑和删除按钮
            self.edit_btn.setEnabled(True)
            self.delete_btn.setEnabled(True)
            
            # 显示详情
            self.show_provider_details(provider_id)
        else:
            self.edit_btn.setEnabled(False)
            self.delete_btn.setEnabled(False)
            self.clear_provider_details()
    
    def show_provider_details(self, provider_id):
        """显示提供商详情"""
        providers = self.config_manager.load_providers()
        if provider_id in providers['providers']:
            info = providers['providers'][provider_id]
            
            self.detail_name_label.setText(info['name'])
            self.detail_base_url_label.setText(info['base_url'])
            
            # API Key显示前8位
            api_key = info.get('api_key', '')
            if api_key:
                masked_key = api_key[:8] + '*' * (len(api_key) - 8) if len(api_key) > 8 else api_key
                self.detail_api_key_label.setText(f"{masked_key} (已设置)")
            else:
                self.detail_api_key_label.setText("未设置")
            
            self.detail_description_label.setText(info.get('description', '无'))
    
    def clear_provider_details(self):
        """清空提供商详情"""
        self.detail_name_label.setText("-")
        self.detail_base_url_label.setText("-")
        self.detail_api_key_label.setText("-")
        self.detail_description_label.setText("-")
    
    def on_combo_changed(self):
        """下拉框选择变化"""
        self.switch_btn.setEnabled(self.provider_combo.currentIndex() >= 0)
    
    def add_provider(self):
        """添加提供商"""
        dialog = ProviderDialog(self)
        if dialog.exec() == QDialog.Accepted:
            data = dialog.get_data()
            
            try:
                self.config_manager.add_provider(
                    data['id'], data['name'], data['base_url'], 
                    data['api_key'], data['description']
                )
                self.log_message(f"✓ 已添加提供商: {data['name']}")
                self.refresh_data()
            except Exception as e:
                QMessageBox.critical(self, "错误", f"添加提供商失败: {str(e)}")
                self.log_message(f"✗ 添加提供商失败: {str(e)}")
    
    def edit_provider(self):
        """编辑提供商"""
        selected_rows = self.providers_table.selectionModel().selectedRows()
        if not selected_rows:
            return
        
        row = selected_rows[0].row()
        provider_id = self.providers_table.item(row, 0).data(Qt.UserRole)
        
        providers = self.config_manager.load_providers()
        provider_data = providers['providers'].get(provider_id)
        
        if provider_data:
            dialog = ProviderDialog(self, provider_data, provider_id)
            if dialog.exec() == QDialog.Accepted:
                data = dialog.get_data()
                
                try:
                    self.config_manager.update_provider(
                        provider_id,
                        name=data['name'],
                        base_url=data['base_url'],
                        api_key=data['api_key'],
                        description=data['description']
                    )
                    self.log_message(f"✓ 已更新提供商: {data['name']}")
                    self.refresh_data()
                except Exception as e:
                    QMessageBox.critical(self, "错误", f"更新提供商失败: {str(e)}")
                    self.log_message(f"✗ 更新提供商失败: {str(e)}")
    
    def delete_provider(self):
        """删除提供商"""
        selected_rows = self.providers_table.selectionModel().selectedRows()
        if not selected_rows:
            return
        
        row = selected_rows[0].row()
        provider_id = self.providers_table.item(row, 0).data(Qt.UserRole)
        provider_name = self.providers_table.item(row, 1).text()
        
        reply = QMessageBox.question(
            self, "确认删除", 
            f"确定要删除提供商 '{provider_name}' 吗？",
            QMessageBox.Yes | QMessageBox.No
        )
        
        if reply == QMessageBox.Yes:
            try:
                self.config_manager.delete_provider(provider_id)
                self.log_message(f"✓ 已删除提供商: {provider_name}")
                self.refresh_data()
            except Exception as e:
                QMessageBox.critical(self, "错误", f"删除提供商失败: {str(e)}")
                self.log_message(f"✗ 删除提供商失败: {str(e)}")
    
    def switch_provider(self):
        """切换提供商"""
        provider_id = self.provider_combo.currentData()
        if not provider_id:
            return
        
        try:
            if self.config_manager.switch_provider(provider_id):
                providers = self.config_manager.load_providers()
                provider_name = providers['providers'][provider_id]['name']
                self.log_message(f"✓ 已切换到: {provider_name}")
                self.status_bar.showMessage(f"已切换到: {provider_name}", 3000)
                self.refresh_data()
            else:
                QMessageBox.warning(self, "切换失败", "提供商配置不完整或不存在")
                self.log_message("✗ 切换失败: 提供商配置不完整")
        except Exception as e:
            QMessageBox.critical(self, "错误", f"切换提供商失败: {str(e)}")
            self.log_message(f"✗ 切换失败: {str(e)}")
    
    def update_status_display(self, env_info):
        """更新状态显示"""
        try:
            # 更新当前提供商显示
            if env_info.get('current_provider'):
                providers = self.config_manager.load_providers()
                provider_name = providers['providers'][env_info['current_provider']]['name']
                self.current_provider_label.setText(f"{provider_name} ({env_info['current_provider']})")
            else:
                self.current_provider_label.setText("未设置")
            
            # 更新Base URL
            base_url = env_info.get('base_url', '')
            if base_url:
                # 截断过长的URL
                display_url = base_url if len(base_url) <= 50 else base_url[:47] + "..."
                self.current_base_url_label.setText(display_url)
                self.current_base_url_label.setToolTip(base_url)
            else:
                self.current_base_url_label.setText("未设置")
                self.current_base_url_label.setToolTip("")
            
            # 更新API Key状态
            api_key = env_info.get('api_key', '')
            if api_key:
                masked_key = api_key[:8] + '*' * max(0, len(api_key) - 8) if len(api_key) > 8 else api_key
                self.current_api_key_label.setText(f"{masked_key} (已设置)")
            else:
                self.current_api_key_label.setText("未设置")
                
        except Exception as e:
            print(f"更新状态显示错误: {e}")
    
    def refresh_data(self):
        """刷新数据"""
        self.load_providers()
        self.log_message("✓ 数据已刷新")
    
    def import_config(self):
        """导入配置"""
        from PySide6.QtWidgets import QFileDialog
        import json
        
        # 选择导入文件
        file_path, _ = QFileDialog.getOpenFileName(
            self, 
            "导入配置文件", 
            "", 
            "JSON文件 (*.json);;所有文件 (*)"
        )
        
        if not file_path:
            return
        
        try:
            # 读取配置文件
            with open(file_path, 'r', encoding='utf-8') as f:
                imported_config = json.load(f)
            
            # 验证配置文件格式
            if 'providers' not in imported_config:
                QMessageBox.warning(self, "导入失败", "配置文件格式不正确，缺少 'providers' 字段")
                return
            
            # 询问导入方式
            from PySide6.QtWidgets import QMessageBox
            reply = QMessageBox.question(
                self, "导入配置", 
                f"找到 {len(imported_config['providers'])} 个提供商配置。\n\n"
                "选择导入方式:\n"
                "• 是(Yes): 合并配置（保留现有配置）\n"
                "• 否(No): 替换配置（清空现有配置）\n"
                "• 取消(Cancel): 取消导入",
                QMessageBox.Yes | QMessageBox.No | QMessageBox.Cancel
            )
            
            if reply == QMessageBox.Cancel:
                return
            
            # 获取当前配置
            current_config = self.config_manager.load_providers()
            
            if reply == QMessageBox.No:
                # 替换模式：清空现有配置
                new_config = imported_config
                imported_count = len(imported_config['providers'])
            else:
                # 合并模式：保留现有配置
                new_config = current_config.copy()
                imported_count = 0
                
                for provider_id, provider_info in imported_config['providers'].items():
                    if provider_id in new_config['providers']:
                        # 询问是否覆盖现有提供商
                        overwrite_reply = QMessageBox.question(
                            self, "提供商冲突", 
                            f"提供商 '{provider_info.get('name', provider_id)}' 已存在。\n"
                            "是否覆盖现有配置？",
                            QMessageBox.Yes | QMessageBox.No
                        )
                        
                        if overwrite_reply == QMessageBox.Yes:
                            new_config['providers'][provider_id] = provider_info
                            imported_count += 1
                    else:
                        new_config['providers'][provider_id] = provider_info
                        imported_count += 1
            
            # 保存新配置
            self.config_manager.save_providers(new_config)
            
            # 刷新界面
            self.refresh_data()
            
            # 显示成功消息
            QMessageBox.information(
                self, "导入成功", 
                f"成功导入 {imported_count} 个提供商配置！"
            )
            
            self.log_message(f"✓ 成功导入配置文件: {file_path}")
            self.log_message(f"✓ 导入了 {imported_count} 个提供商配置")
            
        except json.JSONDecodeError:
            QMessageBox.critical(self, "导入失败", "配置文件格式错误，请检查JSON格式")
            self.log_message(f"✗ 导入失败: JSON格式错误")
        except Exception as e:
            QMessageBox.critical(self, "导入失败", f"导入配置时发生错误:\n{str(e)}")
            self.log_message(f"✗ 导入失败: {str(e)}")
    
    def export_config(self):
        """导出配置"""
        from PySide6.QtWidgets import QFileDialog
        import json
        from datetime import datetime
        
        # 获取当前配置
        config = self.config_manager.load_providers()
        
        if not config.get('providers'):
            QMessageBox.information(self, "导出失败", "没有可导出的配置")
            return
        
        # 生成默认文件名
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        default_filename = f"claude_config_{timestamp}.json"
        
        # 选择保存位置
        file_path, _ = QFileDialog.getSaveFileName(
            self, 
            "导出配置文件", 
            default_filename,
            "JSON文件 (*.json);;所有文件 (*)"
        )
        
        if not file_path:
            return
        
        try:
            # 准备导出数据
            export_data = {
                "export_info": {
                    "version": "1.0.0",
                    "export_time": datetime.now().isoformat(),
                    "total_providers": len(config['providers'])
                },
                "providers": {}
            }
            
            # 询问是否包含敏感信息
            include_keys_reply = QMessageBox.question(
                self, "导出选项", 
                "是否在导出文件中包含API Keys？\n\n"
                "• 是: 包含完整配置（包含API Keys）\n"
                "• 否: 仅导出基本配置（不包含API Keys）\n\n"
                "注意: 包含API Keys的文件请妥善保管！",
                QMessageBox.Yes | QMessageBox.No
            )
            
            include_api_keys = include_keys_reply == QMessageBox.Yes
            
            # 处理每个提供商配置
            for provider_id, provider_info in config['providers'].items():
                export_provider = provider_info.copy()
                
                if not include_api_keys:
                    # 移除敏感信息
                    export_provider['api_key'] = ""
                
                export_data['providers'][provider_id] = export_provider
            
            # 写入文件
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(export_data, f, ensure_ascii=False, indent=2)
            
            # 显示成功消息
            provider_count = len(export_data['providers'])
            keys_info = "包含API Keys" if include_api_keys else "不包含API Keys"
            
            QMessageBox.information(
                self, "导出成功", 
                f"成功导出 {provider_count} 个提供商配置！\n"
                f"文件位置: {file_path}\n"
                f"导出选项: {keys_info}"
            )
            
            self.log_message(f"✓ 成功导出配置文件: {file_path}")
            self.log_message(f"✓ 导出了 {provider_count} 个提供商配置 ({keys_info})")
            
        except Exception as e:
            QMessageBox.critical(self, "导出失败", f"导出配置时发生错误:\n{str(e)}")
            self.log_message(f"✗ 导出失败: {str(e)}")
    
    def show_about(self):
        """显示关于对话框"""
        QMessageBox.about(
            self, "关于",
            "Claude Code 配置管理器\n\n"
            "版本: 1.0.0\n"
            "支持多个AI提供商的配置管理和快速切换\n\n"
            "支持的提供商:\n"
            "• 阿里云通义千问\n"
            "• Kimi (月之暗面)\n"
            "• 智谱 GLM-4.5\n"
            "• 自定义提供商"
        )
    
    def log_message(self, message):
        """记录日志消息"""
        from datetime import datetime
        from PySide6.QtGui import QTextCursor
        timestamp = datetime.now().strftime("%H:%M:%S")
        self.log_text.append(f"[{timestamp}] {message}")
        
        # 自动滚动到底部
        cursor = self.log_text.textCursor()
        cursor.movePosition(QTextCursor.MoveOperation.End)
        self.log_text.setTextCursor(cursor)
    
    def closeEvent(self, event):
        """关闭事件"""
        if self.status_thread:
            self.status_thread.stop()
        event.accept()

def main():
    """主函数"""
    app = QApplication(sys.argv)
    
    # 设置应用信息
    app.setApplicationName("Claude Code 配置管理器")
    app.setApplicationVersion("1.0.0")
    app.setOrganizationName("Claude Code Team")
    
    # 创建主窗口
    window = ClaudeConfigGUI()
    window.show()
    
    # 运行应用
    sys.exit(app.exec())

if __name__ == '__main__':
    main()