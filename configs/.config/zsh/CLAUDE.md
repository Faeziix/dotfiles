# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains ZSH configurations and customizations, primarily focusing on:

1. Core ZSH settings, keybindings, and options
2. Completion system configuration
3. Plugin management and integration 
4. Custom functions and aliases

## Key Components

### ZSH Configuration Structure

- `.zshrc` - Main configuration file containing core settings, plugin setup, and includes
- `.aliases` - Collection of aliases for various commands and tools
- `bd.zsh` - Back-directory navigation plugin
- `fzf-tab/` - Integration of fzf (fuzzy finder) with ZSH tab completion
- `zcompdump` - Cache file for ZSH completion system

### Notable Plugins and Tools

- `fzf-tab` - Replaces ZSH's default completion selection menu with fzf
- `bd` (back-directory) - Quickly navigate back to a specific parent directory
- External plugins (referenced in .zshrc):
  - zsh-vi-mode
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zoxide
  - starship prompt

## Working with This Repository

### Testing ZSH Configuration Changes

When modifying ZSH configuration files, you can test changes by:

```bash
# Test configuration without affecting current shell
zsh -c "source ~/.zshrc"

# Apply changes to current shell
source ~/.zshrc
```

### Managing Completion System

```bash
# Force rebuild of ZSH completion cache
rm ~/.config/zsh/zcompdump
compinit -d ~/.config/zsh/zcompdump
```

### Working with fzf-tab

The fzf-tab plugin enhances tab completion with fuzzy search. When working with this component:

```bash
# Test fzf-tab in isolation
source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh

# Build the optional binary module for better performance
cd ~/.config/zsh/fzf-tab
build-fzf-tab-module
```

### Important Configuration Notes

1. Plugin loading order matters - fzf-tab needs to be loaded after `compinit` but before other widget-wrapping plugins
2. Custom key bindings use VI mode (`bindkey -v`)
3. The `.zshrc` file is structured in clear sections for organization
4. Many aliases and functions are tailored to this specific environment