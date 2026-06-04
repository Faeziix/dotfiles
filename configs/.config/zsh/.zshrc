# ============================================================
# ZSH — thin loader.
# All real configuration lives in conf.d/, sourced in numeric order:
#   00-options  10-history  20-completion  30-keybindings  40-prompt
#   50-plugins  60-colors   70-paths       80-aliases      90-functions
# On-demand helpers (fzf, syntax-highlighting) live in lib/.
# Secrets are sourced from ~/.zshenv -> $ZDOTDIR/.secrets (gitignored).
# ============================================================

# Optional startup profiling: `ZSH_PROFILE=1 zsh` then read the zprof report.
[[ -n $ZSH_PROFILE ]] && zmodload zsh/zprof

for _zrc in "$ZDOTDIR"/conf.d/*.zsh(N); do
    source "$_zrc"
done
unset _zrc

[[ -n $ZSH_PROFILE ]] && zprof
