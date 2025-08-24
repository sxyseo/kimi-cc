# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code configuration manager that enables users to switch between different AI providers (Qwen, Kimi, Zhipu GLM-4.5, and custom providers) as alternatives to the official Anthropic Claude API. The project provides both GUI and CLI tools for managing AI provider configurations.

## Development Commands

### Building and Packaging
- `python build.py` - Build cross-platform executables (recommended)
- `./build_unix.sh` - Build on Unix/Linux/macOS systems
- `build_windows.bat` - Build on Windows systems
- `python build_simple.py` - Simple build script alternative

### Running Applications
- `python claude_config_gui.py` - Launch GUI configuration manager
- `python start_gui.py` - Auto-install dependencies and launch GUI
- `python config_manager.py` - Command-line configuration management
- `python switch_provider.py <provider>` - Quick provider switching

### Configuration Management
- `python config_manager.py list` - List all configured providers
- `python config_manager.py status` - Show current provider status
- `python config_manager.py add <id> <name> <base_url> <api_key>` - Add new provider
- `python config_manager.py update <id> [--name|--base_url|--api_key|--description]` - Update provider
- `python config_manager.py delete <id>` - Delete provider
- `python config_manager.py export <file> [--include-keys]` - Export configuration
- `python config_manager.py import <file> [--merge] [--force]` - Import configuration

## Architecture Overview

### Core Components

#### Configuration Management
- `config_manager.py` - Core configuration management class with provider switching, environment variable setup, and config persistence
- `ConfigManager` class handles provider storage, environment variable management, and cross-platform shell configuration updates

#### GUI Application
- `claude_config_gui.py` - PySide6-based GUI application with provider management, real-time status monitoring, and import/export functionality
- `ProviderDialog` class for adding/editing providers
- `StatusUpdateThread` for real-time environment variable monitoring

#### Command Line Tools
- `switch_provider.py` - Simple CLI for quick provider switching
- `start_gui.py` - Auto-dependency installer and GUI launcher

#### Build System
- `build.py` - Comprehensive cross-platform build system using PyInstaller
- Supports creating standalone executables for Windows, Linux, and macOS
- Handles dependency checking, build cleanup, and release packaging

### Configuration Storage

#### File Structure
- Configuration files stored in `~/.claude_code_config/` (Unix) or `%USERPROFILE%\.claude_code_config\` (Windows)
- `providers.json` - All provider configurations with API keys and base URLs
- `current.json` - Currently active provider tracking

#### Environment Variables
- `ANTHROPIC_BASE_URL` - API endpoint URL for the selected provider
- `ANTHROPIC_AUTH_TOKEN` - API key for authentication

#### Supported Providers
- **qwen**: Alibaba Cloud Qwen (DashScope API)
- **kimi**: Moonshot Kimi API
- **zhipu**: Zhipu AI GLM-4.5 API
- **custom**: User-defined providers

### Key Design Patterns

#### Cross-Platform Compatibility
- Platform-specific environment variable setting (Windows setx vs Unix shell config)
- Automatic shell detection (.bashrc, .zshrc, .fish)
- Executable file extensions and permission handling

#### Security Considerations
- API key masking in UI displays
- Optional API key inclusion in exports
- Secure configuration file storage in user directory

#### Import/Export System
- JSON-based configuration format with metadata
- Merge vs replace import modes
- Conflict resolution for duplicate providers

## Development Guidelines

### Code Structure
- Keep core configuration logic in `config_manager.py`
- GUI components should use the ConfigManager class for all operations
- CLI tools should provide simple interfaces to core functionality
- Build scripts should handle dependency checking and error recovery

### Error Handling
- Validate provider configurations before switching
- Handle missing dependencies gracefully
- Provide clear error messages for common issues
- Log operations for debugging and user feedback

### Testing Provider Configurations
- Test environment variable setting across platforms
- Verify API endpoint connectivity
- Validate configuration file format and permissions
- Test import/export functionality with various scenarios

### Build System
- Use PyInstaller for creating standalone executables
- Include all necessary dependencies and data files
- Handle platform-specific build requirements
- Generate build logs and usage documentation

### Dependencies
- Runtime: PySide6 (for GUI), standard library
- Build: PyInstaller, PySide6
- Python version: 3.6+ recommended
- No external API calls - configuration management only

## Configuration File Format

### providers.json Structure
```json
{
  "providers": {
    "provider_id": {
      "name": "Display Name",
      "base_url": "https://api.example.com/",
      "api_key": "sk-...",
      "description": "Optional description"
    }
  }
}
```

### current.json Structure
```json
{
  "current_provider": "provider_id"
}
```

## Important Notes

- This tool only manages configuration - it doesn't make API calls or handle AI interactions
- Environment variables are set system-wide and may require terminal restart
- Configuration files contain sensitive API keys and should be handled securely
- The tool is designed to work with Claude Code by setting the appropriate environment variables
- Build executables are standalone and don't require Python installation on target systems