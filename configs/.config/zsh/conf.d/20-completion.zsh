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

# carapace — multi-shell argument completions for 1000+ commands (docker, gh, bun,
# systemctl, cargo, ...). Must source after compinit. The 'zsh' bridge makes carapace
# fall back to native zsh completions for any command it doesn't know (bun, stripe, ...),
# so this augments rather than replaces the existing setup. Loaded before fzf-tab so
# fzf-tab wraps carapace's candidates with the usual previews.
if command -v carapace >/dev/null; then
    export CARAPACE_BRIDGES='zsh'
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    source <(carapace _carapace zsh)

    # carapace also hijacks plain file-argument commands (cat, cp, nvim, ls, ...),
    # but its zsh bridge drops single-match completions (the generated completer
    # guards with `${#valuesArr} -gt 1`), so descending into a folder with one
    # match — or completing a lone sub-directory — inserts nothing. Hand those
    # file/dir-centric commands back to zsh's native completion, which fzf-tab
    # already wraps with folder descent + previews. carapace still enriches the
    # commands that actually benefit (docker, gh, git, systemctl, cargo, ...).
    carapace_native_file_cmds=(
        ls lsd eza cat bat tac nl head tail less more wc
        cp mv rm rmdir mkdir touch ln chmod chown chgrp stat file du
        nvim vim vi view gvim nano micro code subl
        tar zip unzip gzip gunzip xz zstd source realpath readlink
    )
    compdef -d $carapace_native_file_cmds 2>/dev/null
    unset carapace_native_file_cmds
fi

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
