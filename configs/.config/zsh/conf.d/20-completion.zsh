# vim: ft=zsh
# Completion system

autoload -Uz compinit
# Only rebuild the completion dump once a day; otherwise load it cached (-C) for faster startup
if [[ -n ~/.config/zsh/zcompdump(#qN.mh+24) ]]; then
  compinit -d ~/.config/zsh/zcompdump
else
  compinit -C -d ~/.config/zsh/zcompdump
fi
_comp_options+=(globdots)    # Include hidden files in completion

# Extra completion search paths
fpath=(~/.stripe $fpath)

setopt GLOB_COMPLETE        # Show the completion menu when globbing
setopt MENU_COMPLETE        # Highlight the first menu entry automatically
setopt AUTO_LIST            # List choices on ambiguous completion
setopt COMPLETE_IN_WORD     # Complete from both ends of a word

# Vi-style navigation inside the completion menu (needs complist)
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# fzf-tab — must load after compinit but before widget-wrapping plugins (see 50-plugins.zsh)
if [[ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
else
    source "$ZDOTDIR/fzf-tab/fzf-tab.plugin.zsh"
fi

# Completion styling
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*:git-checkout:*' sort false

# fzf-tab previews
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
# Make the popup a few rows taller than the list so the reverse layout leaves
# blank space underneath it (instead of hugging the bottom of the screen)
zstyle ':fzf-tab:*' fzf-min-height 20
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  '[[ -d $realpath ]] && lsd -1 --color=always $realpath || bat --color=always --line-range :200 $realpath 2>/dev/null || echo $realpath'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word 2>/dev/null'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'
