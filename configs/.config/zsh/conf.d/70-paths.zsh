# vim: ft=zsh
# PATH and environment
#
# Note: API keys and other secrets live in ~/.zshenv -> $ZDOTDIR/.secrets (gitignored).

# PATH additions
export PATH="$HOME/.local/share/cargo/bin:$PATH"          # Rust / cargo
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"   # asdf shims

# Composio CLI
export COMPOSIO_INSTALL_DIR="/home/faezix/.composio"
export PATH="$COMPOSIO_INSTALL_DIR:$PATH"

# Use nvim as the man pager (overrides the `less` default from ~/.zshenv)
export MANPAGER='nvim +Man!'

# ROCm GPU override
export HSA_OVERRIDE_GFX_VERSION=11.0.0

# Bun completion
[ -s "/home/faezix/.bun/_bun" ] && source "/home/faezix/.bun/_bun"
