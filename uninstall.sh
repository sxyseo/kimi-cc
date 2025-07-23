#!/bin/bash

set -e

echo "================================================================"
echo "           Claude Code Environment Cleanup Script"
echo "================================================================"
echo "This script will remove Claude Code environment variables and configuration"
echo "================================================================"
echo ""

# Function to remove lines from file
remove_env_vars_from_file() {
    local file_path="$1"
    local backup_file="${file_path}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [ -f "$file_path" ]; then
        echo "📝 Processing $file_path..."
        
        # Create backup
        cp "$file_path" "$backup_file"
        echo "   ✅ Backup created: $backup_file"
        
        # Remove Claude Code related environment variables
        if grep -q "ANTHROPIC_BASE_URL\|ANTHROPIC_API_KEY\|Claude Code environment variables" "$file_path"; then
            # Remove lines containing Claude Code environment variables
            sed -i.tmp '/# Claude Code environment variables/d' "$file_path" 2>/dev/null || true
            sed -i.tmp '/export ANTHROPIC_BASE_URL/d' "$file_path" 2>/dev/null || true
            sed -i.tmp '/export ANTHROPIC_API_KEY/d' "$file_path" 2>/dev/null || true
            
            # Clean up temporary file
            rm -f "${file_path}.tmp" 2>/dev/null || true
            
            echo "   ✅ Environment variables removed from $file_path"
            return 0
        else
            echo "   ℹ️  No Claude Code environment variables found in $file_path"
            # Remove backup since no changes were made
            rm -f "$backup_file"
            return 1
        fi
    else
        echo "   ⚠️  File $file_path does not exist"
        return 1
    fi
}

# Detect current shell and determine rc files to check
current_shell=$(basename "$SHELL")
rc_files=()

case "$current_shell" in
    bash)
        rc_files=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile")
        ;;
    zsh)
        rc_files=("$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.profile")
        ;;
    fish)
        rc_files=("$HOME/.config/fish/config.fish")
        ;;
    *)
        rc_files=("$HOME/.profile" "$HOME/.bashrc" "$HOME/.bash_profile")
        ;;
esac

echo "🔍 Searching for Claude Code environment variables..."
echo ""

# Track if any changes were made
changes_made=false

# Process each potential rc file
for rc_file in "${rc_files[@]}"; do
    if remove_env_vars_from_file "$rc_file"; then
        changes_made=true
    fi
done

echo ""

# Remove .claude.json configuration file
claude_config="$HOME/.claude.json"
if [ -f "$claude_config" ]; then
    echo "🗑️  Removing Claude Code configuration file..."
    
    # Create backup
    backup_config="${claude_config}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$claude_config" "$backup_config"
    echo "   ✅ Backup created: $backup_config"
    
    # Remove the file
    rm -f "$claude_config"
    echo "   ✅ Removed: $claude_config"
    changes_made=true
else
    echo "ℹ️  Claude Code configuration file not found: $claude_config"
fi

echo ""

# Unset environment variables from current session
echo "🧹 Clearing environment variables from current session..."
unset ANTHROPIC_BASE_URL
unset ANTHROPIC_API_KEY
echo "   ✅ Environment variables cleared from current session"

echo ""

if [ "$changes_made" = true ]; then
    echo "✅ Cleanup completed successfully!"
    echo ""
    echo "📋 Summary of actions taken:"
    echo "   • Environment variables removed from shell configuration files"
    echo "   • .claude.json configuration file removed"
    echo "   • Current session environment variables cleared"
    echo "   • Backup files created for safety"
    echo ""
    echo "🔄 To ensure all changes take effect:"
    echo "   • Restart your terminal, or"
    echo "   • Run: source ~/.bashrc (or your shell's rc file)"
    echo ""
    echo "📁 Backup files location:"
    echo "   • Shell config backups: *.backup.*"
    echo "   • Claude config backup: $HOME/.claude.json.backup.*"
else
    echo "ℹ️  No Claude Code environment variables or configuration found."
    echo "   System is already clean."
fi

echo ""
echo "🎉 Claude Code environment cleanup completed!"
