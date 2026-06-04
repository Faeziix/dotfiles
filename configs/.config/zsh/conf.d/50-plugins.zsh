# vim: ft=zsh
# Plugins
#
# Load order matters: fzf-tab is sourced earlier (20-completion.zsh) so it sits
# before the widget-wrapping plugins below; syntax-highlighting is sourced last.

# zsh-vi-mode resets the keymaps on init, so anything that binds keys (fzf, atuin,
# pay-respects) is deferred via zvm_after_init_commands to run *after* that reset.
if [[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    # fzf's completion.zsh rebinds Tab, so reclaim it for fzf-tab right after
    zvm_after_init_commands+=('[ -f "$ZDOTDIR/lib/fzf.zsh" ] && source "$ZDOTDIR/lib/fzf.zsh"; (( $+functions[enable-fzf-tab] )) && enable-fzf-tab')
    if command -v atuin >/dev/null; then
        zvm_after_init_commands+=('eval "$(atuin init zsh --disable-up-arrow)"')
        # atuin doesn't bind ^R in the vicmd keymap, so bind it after fzf to win in normal mode too
        zvm_after_init_commands+=('bindkey -M vicmd "^R" atuin-search-vicmd; bindkey -M viins "^R" atuin-search-viins')
    fi
    command -v pay-respects >/dev/null && zvm_after_init_commands+=('eval "$(pay-respects zsh --nocnf --alias f)"')
else
    [ -f "$ZDOTDIR/lib/fzf.zsh" ] && source "$ZDOTDIR/lib/fzf.zsh"
    (( $+functions[enable-fzf-tab] )) && enable-fzf-tab
    if command -v atuin >/dev/null; then
        eval "$(atuin init zsh --disable-up-arrow)"
        bindkey -M vicmd "^R" atuin-search-vicmd
        bindkey -M viins "^R" atuin-search-viins
    fi
    command -v pay-respects >/dev/null && eval "$(pay-respects zsh --nocnf --alias f)"
fi

# Autosuggestions
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^ ' autosuggest-execute
    bindkey '^o' autosuggest-accept
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# Syntax highlighting — must be the last widget-wrapping plugin sourced
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source "$ZDOTDIR/lib/syntax-highlighting.zsh"
fi

# bd — jump back to a named parent directory
source "$ZDOTDIR/bd.zsh"

# zoxide — smarter cd (provides `z`)
eval "$(zoxide init zsh)"

# you-should-use — remind me when an alias exists for what I typed
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
