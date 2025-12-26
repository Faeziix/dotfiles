# Keybindings Configuration

# Use vi keybindings
bindkey -v

# Keybindings for history search
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# Navigation shortcuts
bindkey '^[[1;5C' forward-word  # Ctrl+Right
bindkey '^[[1;5D' backward-word # Ctrl+Left

# Edit the command line with the editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
