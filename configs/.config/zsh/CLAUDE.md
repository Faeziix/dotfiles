# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains a modular ZSH configuration. `.zshrc` is a thin loader; all
real configuration lives in `conf.d/` and is sourced in numeric order.

## Configuration Structure

```
.zshrc                 Thin loader — sources conf.d/*.zsh in numeric order
conf.d/
  00-options.zsh       setopt core options, WORDCHARS
  10-history.zsh       HISTFILE/HISTSIZE and history setopts
  20-completion.zsh    compinit (daily-cached), fzf-tab, completion zstyles + previews
  30-keybindings.zsh   vi mode, edit-command-line (^e), magic-space
  40-prompt.zsh        starship + bottom-of-screen prompt hook
  50-plugins.zsh       zsh-vi-mode, atuin, pay-respects, autosuggestions,
                       syntax-highlighting, bd, zoxide, you-should-use
  60-colors.zsh        dircolors, colored man pages
  70-paths.zsh         PATH, env, bun/asdf/composio
  80-aliases.zsh       all aliases
  90-functions.zsh     mkcd, extract, download, tmux_force, command-not-found, log_time
lib/
  fzf.zsh              fzf env vars + completion/key-bindings (deferred-loaded)
  syntax-highlighting.zsh   custom zsh-syntax-highlighting styles (deferred-loaded)
.secrets               API keys — gitignored, sourced from ~/.zshenv (NOT ~/.config/zsh/.zshrc)
bd.zsh                 vendored back-directory plugin
fzf-tab/               vendored fzf-tab (fallback; system package preferred — see below)
zcompdump              completion cache (gitignored)
```

## Notable Tools

- `fzf-tab` — fzf-powered tab completion menu. Sourced from the system package
  (`/usr/share/zsh/plugins/fzf-tab/`) with a fallback to the vendored `fzf-tab/`.
- `atuin` — full-screen `Ctrl-R` history search (up-arrow left as plain history via `--disable-up-arrow`).
- `pay-respects` — `f` re-runs a corrected version of the previous failed command.
- `bd` — jump back to a named parent directory.
- `zoxide` (`z`), `starship` prompt, `zsh-vi-mode`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `you-should-use`.

## Testing Changes

```bash
# Syntax-check every module
for f in ~/.config/zsh/.zshrc ~/.config/zsh/conf.d/*.zsh ~/.config/zsh/lib/*.zsh; do zsh -n "$f"; done

# Apply to current shell
source ~/.zshrc

# Inspect a keybinding in a real interactive shell (zvm/atuin/fzf are deferred to first prompt)
zsh -is <<< 'bindkey -M viins "^R"; bindkey "^I"'
```

## Important Notes (load-order / gotchas)

1. **Secrets** live in `.secrets` (gitignored) and are sourced from `~/.zshenv` so they
   reach non-interactive shells too. Never inline keys into a tracked file.
2. **`zsh-vi-mode` resets the keymaps on init**, so every key-binding tool (fzf, atuin,
   pay-respects, and the fzf-tab Tab reclaim) is deferred via `zvm_after_init_commands`
   in `50-plugins.zsh`. Binding keys outside that hook will silently not stick.
3. **fzf-tab vs fzf completion**: fzf's `completion.zsh` rebinds `Tab` to `fzf-completion`,
   which would clobber fzf-tab. `50-plugins.zsh` calls `enable-fzf-tab` right after loading
   fzf to reclaim `Tab` for `fzf-tab-complete`.
4. **Plugin order**: fzf-tab loads after `compinit` (in `20-completion.zsh`) and before the
   widget-wrapping plugins; `zsh-syntax-highlighting` is sourced last.
5. `compinit` rebuilds the dump only once a day (cached `-C` load otherwise) for faster startup.
6. To profile startup: `ZSH_PROFILE=1 zsh` then read the `zprof` report.
