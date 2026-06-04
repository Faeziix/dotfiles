# vim: ft=zsh
# Keybindings (base layer — plugin-specific binds live in 50-plugins.zsh)

bindkey -v                  # Use vi keybindings
KEYTIMEOUT=1                # Remove the mode-switch delay

# Edit the current command line in $EDITOR with Ctrl-e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Do history expansion on space
bindkey ' ' magic-space
