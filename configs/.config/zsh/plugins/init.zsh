# Plugin Configuration

# List of plugins used
plugins=()

# Load fzf-tab plugin if available
if [[ -f "$ZDOTDIR/fzf-tab/fzf-tab.plugin.zsh" ]]; then
    source "$ZDOTDIR/fzf-tab/fzf-tab.plugin.zsh"
fi

# Load bd.zsh if available
if [[ -f "$ZDOTDIR/bd.zsh" ]]; then
    source "$ZDOTDIR/bd.zsh"
fi

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
   aurhelper="paru"
fi

# Pokemon colorscripts (if installed)
command -v pokemon-colorscripts >/dev/null && pokemon-colorscripts --no-title -r 1,3,6