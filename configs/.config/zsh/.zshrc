# ====================================
# ZSH Configuration File
# ====================================

# ====================================
# Core Settings
# ====================================
setopt autocd               # Change directory just by typing its name
# setopt correct             # Auto correct mistakes
setopt interactivecomments  # Allow comments in interactive mode
setopt magicequalsubst      # Enable filename expansion for arguments of the form 'anything=expression'
setopt nonomatch            # Hide error message if there is no match for the pattern
setopt notify               # Report the status of background jobs immediately
setopt numericglobsort      # Sort filenames numerically when it makes sense
setopt promptsubst          # Enable command substitution in prompt
setopt auto_pushd           # Push the current directory visited on the stack
setopt pushd_ignore_dups    # Do not store duplicates in the stack
setopt pushd_silent         # Do not print the directory stack after pushd or popd
setopt EXTENDED_GLOB        # Enable extended globbing

# Remove specific characters from WORDCHARS
WORDCHARS=${WORDCHARS//\/}

# Keybinding configuration
bindkey -v                  # Use vi keybindings
KEYTIMEOUT=1                # Remove mode switching delay

# Edit line in vim with ctrl-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# ====================================
# History Configuration
# ====================================
HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=20000

setopt hist_expire_dups_first  # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups        # Ignore duplicated commands history list
setopt hist_ignore_space       # Ignore commands that start with space
setopt hist_verify             # Show command with history expansion to user before running it
setopt share_history           # Share command history data

# Force zsh to show the complete history
alias history="history 0"

# ====================================
# Prompt Configuration
# ====================================
# Bottom prompt function
autoload -Uz add-zsh-hook
function bottom_prompt {
  tput cup $(($LINES-2)) 0
}
add-zsh-hook precmd bottom_prompt

# Starship prompt
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship-prompt/starship.toml

# ====================================
# Completion System
# ====================================
autoload -Uz compinit
compinit -d ~/.config/zsh/zcompdump
_comp_options+=(globdots)    # Include hidden files

# Add additional fpath
fpath=(~/.stripe $fpath)

# Completion options
setopt GLOB_COMPLETE        # Show autocompletion menu with globs
setopt MENU_COMPLETE        # Automatically highlight first element of completion menu
setopt AUTO_LIST            # Automatically list choices on ambiguous completion
setopt COMPLETE_IN_WORD     # Complete from both ends of a word

# Basic completion configuration
bindkey ' ' magic-space      # Do history expansion on space

# Menu selection keybindings
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# FZF-Tab configuration
source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh

# Completion styling
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# Task-specific completion settings
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'

# ====================================
# Plugins
# ====================================
# VI Mode
if [[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    zvm_after_init_commands+=('[ -f "$ZDOTDIR/.fzf.zsh" ] && source "$ZDOTDIR/.fzf.zsh"')
else
    [ -f "$ZDOTDIR/.fzf.zsh" ] && source "$ZDOTDIR/.fzf.zsh"
fi

# Auto-suggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^ ' autosuggest-execute
    bindkey '^o' autosuggest-accept
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# Syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  . "$ZDOTDIR/.syntax-highlighting.zsh"
fi

# BD (back directory) plugin
source "$ZDOTDIR/bd.zsh"

# Zoxide (smart cd)
eval "$(zoxide init zsh)"

# ====================================
# Color Support
# ====================================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    # Color for common commands
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    # Less colors for man pages
    export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
    export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
    export LESS_TERMCAP_me=$(tput sgr0)
    export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
    export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
    export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
    export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
    export LESS_TERMCAP_mr=$(tput rev)
    export LESS_TERMCAP_mh=$(tput dim)
    export LESS_TERMCAP_ZN=$(tput ssubm)
    export LESS_TERMCAP_ZV=$(tput rsubm)
    export LESS_TERMCAP_ZO=$(tput ssupm)
    export LESS_TERMCAP_ZW=$(tput rsupm)
    export GROFF_NO_SGR=1

    # Use colors for completion
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# ====================================
# Path Configuration
# ====================================
# Rust path
export PATH="$HOME/.local/share/cargo/bin:$PATH"

# ====================================
# External Files
# ====================================
# Source aliases
source "$ZDOTDIR/.aliases"

# Bun completion
[ -s "/home/faezix/.bun/_bun" ] && source "/home/faezix/.bun/_bun"

# ====================================
# Custom Functions
# ====================================
# Tmux force function
tmux_force() {
    # Check if tmux is installed
    if ! command -v tmux >/dev/null 2>&1; then
        echo -e "\033[31mError: tmux is not installed.\033[0m" >&2
        return 1
    fi
    # Check if already in a tmux session
    if [ -n "$TMUX" ]; then
        echo -e "\033[31mError: Already in a tmux session.\033[0m" >&2
        return 1
    fi
    # Try to attach to an existing session or create a new one
    if tmux has-session -t '\~' 2>/dev/null; then
        if ! tmux attach-session -t '\~' 2>/dev/null; then
            echo -e "\033[31mError: Failed to attach to tmux session '~'.\033[0m" >&2
            return 1
        fi
    else
        if ! tmux new-session -s '~' -c '~' 2>/dev/null; then
            echo -e "\033[31mError: Failed to create new tmux session '~'.\033[0m" >&2
            return 1
        fi
    fi
    # Infinite loop to reattach if detached
    while tmux has-session 2>/dev/null; do
        if ! tmux attach 2>/dev/null; then
            echo -e "\033[31mError: Failed to reattach to tmux.\033[0m" >&2
            return 1
        fi
    done
    return 0
}

# ====================================
# Debugging Tools
# ====================================
# Function to log elapsed time
enable_timing=false
log_time() {
  if $enable_timing; then
    local step=$1
    local current_time=$(date +%s%N)
    local elapsed=$(( (current_time - START_TIME) / 1000000 ))  # in milliseconds
    echo "Time taken until $step: ${elapsed} ms"
    START_TIME=$current_time
  fi
}
START_TIME=$(date +%s%N)
