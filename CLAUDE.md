# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a personal dotfiles/macprofile configuration repository containing settings and configurations for various development tools and environment setup across Linux, macOS, and Windows platforms.

## Directory Structure

- `profile/` - Shell configuration files (bash functions, dev profile setup)
- `vim/` - Vim configuration with plugin management via vim-plug
- `vscode/` - VS Code settings and keybindings
- `tmux/` - tmux configuration (tmux.conf, tmux.conf.local)
- `terminal/` - Terminal theme configurations (e.g., Dracula.terminal)
- `git/` - Git configuration and aliases
- `gradle/`, `docker/` - Build tool and container configs
- `linux_dev/`, `mac_dev/`, `win_dev/` - Platform-specific development configurations

## Key Configuration Files

- `profile/default.conf` - Shadowrocket VPN routing rules (network proxy configuration)
- `profile/bashfunc.sh` - Common bash functions and utilities
- `profile/devprofile.sh` - Development environment setup
- `vim/vimrc` - Main Vim configuration with plugins, YouCompleteMe, vim-go, and code formatting tools
- `vscode/settings.json` - VS Code user settings
- `tmux/tmux.conf` - Main tmux configuration
- `tmux/tmux.conf.local` - Local/user tmux overrides

## Development Tools Reference

### Vim Plugins
Uses vim-plug for plugin management. Key plugins:
- YouCompleteMe (semantic code completion)
- vim-go (Golang development)
- NERDTree (file tree)
- LeaderF (fuzzy file/command finding)
- vim-airline (status bar)

### External Dependencies for Vim
- ripgrep (rg) - for LeaderF search
- ctags - for Tagbar code outline
- gotags (Go) - for Go code tagging
- shfmt/shell formatting tools

### Formatters
- autopep8 (Python)
- sqlparse (SQL)
- js-beautify (JS/JSON)
- clang-format (C/Google style)