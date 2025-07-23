# Claude Code Environment Cleanup Scripts

This directory contains cleanup scripts to remove Claude Code environment variables and configuration files from your system.

## 📁 Available Scripts

### Linux/macOS
- **`uninstall.sh`** - Cleanup script for Unix-like systems (Linux, macOS)

### Windows
- **`uninstall_claude.bat`** - Cleanup script for Windows systems

## 🧹 What These Scripts Remove

Both scripts will clean up the following:

### Environment Variables
- `ANTHROPIC_BASE_URL`
- `ANTHROPIC_API_KEY`

### Configuration Files
- `~/.claude.json` (Linux/macOS) or `%USERPROFILE%\.claude.json` (Windows)

### Shell Configuration Files (Linux/macOS only)
- Removes environment variable exports from:
  - `~/.bashrc`
  - `~/.bash_profile`
  - `~/.zshrc`
  - `~/.zprofile`
  - `~/.profile`
  - `~/.config/fish/config.fish`

## 🚀 Usage Instructions

### Linux/macOS

1. **Make the script executable** (if needed):
   ```bash
   chmod +x uninstall.sh
   ```

2. **Run the cleanup script**:
   ```bash
   ./uninstall.sh
   ```

3. **Restart your terminal** or source your shell configuration:
   ```bash
   source ~/.bashrc  # or your shell's rc file
   ```

### Windows

1. **Run as Administrator** (recommended):
   - Right-click on `uninstall_claude.bat`
   - Select "Run as administrator"

2. **Or run normally**:
   - Double-click `uninstall_claude.bat`
   - Or run from Command Prompt: `uninstall_claude.bat`

3. **Restart your command prompt** or PowerShell window

## 🔒 Safety Features

### Automatic Backups
Both scripts create automatic backups before making any changes:

**Linux/macOS:**
- Shell config backups: `filename.backup.YYYYMMDD_HHMMSS`
- Claude config backup: `~/.claude.json.backup.YYYYMMDD_HHMMSS`

**Windows:**
- Claude config backup: `%USERPROFILE%\.claude.json.backup.YYYYMMDD_HHMM`

### Non-Destructive Operation
- Scripts only remove Claude Code related entries
- Other environment variables and configurations remain untouched
- Backup files are created before any modifications

## ✅ Verification

After running the cleanup scripts, you can verify the cleanup was successful:

### Linux/macOS
```bash
echo $ANTHROPIC_BASE_URL
echo $ANTHROPIC_API_KEY
# Should return empty values

ls -la ~/.claude.json
# Should return "No such file or directory"
```

### Windows

**Command Prompt:**
```cmd
echo %ANTHROPIC_BASE_URL%
echo %ANTHROPIC_API_KEY%
# Should return the variable names (not values) or empty

dir %USERPROFILE%\.claude.json
# Should return "File Not Found"
```

**PowerShell:**
```powershell
echo $env:ANTHROPIC_BASE_URL
echo $env:ANTHROPIC_API_KEY
# Should return empty values

Test-Path $env:USERPROFILE\.claude.json
# Should return False
```

## 🔧 Manual Cleanup (If Scripts Fail)

If the automated scripts don't work for any reason, you can manually clean up:

### Manual Environment Variable Removal

**Linux/macOS:**
1. Edit your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.)
2. Remove lines containing:
   ```bash
   export ANTHROPIC_BASE_URL=...
   export ANTHROPIC_API_KEY=...
   ```
3. Remove the configuration file: `rm ~/.claude.json`

**Windows:**
1. **GUI Method:**
   - Right-click "This PC" → Properties → Advanced System Settings
   - Click "Environment Variables"
   - Remove `ANTHROPIC_BASE_URL` and `ANTHROPIC_API_KEY` from both User and System variables

2. **Command Line Method:**
   ```cmd
   reg delete "HKEY_CURRENT_USER\Environment" /v ANTHROPIC_BASE_URL /f
   reg delete "HKEY_CURRENT_USER\Environment" /v ANTHROPIC_API_KEY /f
   del "%USERPROFILE%\.claude.json"
   ```

## 🆘 Troubleshooting

### Permission Issues
- **Linux/macOS:** Ensure you have write permissions to your home directory and shell config files
- **Windows:** Run the script as Administrator for complete cleanup

### Backup Recovery
If you need to restore your configuration:

**Linux/macOS:**
```bash
# Restore shell config
cp ~/.bashrc.backup.YYYYMMDD_HHMMSS ~/.bashrc

# Restore Claude config
cp ~/.claude.json.backup.YYYYMMDD_HHMMSS ~/.claude.json
```

**Windows:**
```cmd
# Restore Claude config
copy "%USERPROFILE%\.claude.json.backup.YYYYMMDD_HHMM" "%USERPROFILE%\.claude.json"
```

## 📞 Support

For issues or questions:
- Visit: https://github.com/sxyseo/qwen-cc
- Check the main installation scripts for reference

---

**Note:** These cleanup scripts are designed to be safe and non-destructive. They only remove Claude Code related configurations and create backups of all modified files.
