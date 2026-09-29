# Project: tmux config

## Overview
- **Type**: tmux configuration (part of ~/.dotfiles, symlinked to ~/.config/tmux)
- **Stack**: tmux 3.7c, tpm plugins, kitty terminal, niri compositor
- **Package Manager**: bun
- **Started**: 2026-09-29 (this file)

## Architecture Decisions
- File layout: `tmux.conf` (options, keys, plugins) → `theme.conf` (catppuccin options, sourced BEFORE tpm because the plugin only sets unset options) → tpm `run` → `status.conf` (status bar, sourced AFTER tpm so it overrides catppuccin and can use `@thm_*`). Custom status modules live one per file in `modules/`; shell helpers in `scripts/`.
- Status bar: left = COPY / SYNC badges (zoom is shown inside the window tab, never as a separate badge: peach zoom icon + pane count in `@window_label`; the catppuccin zoom flag is dropped from `@catppuccin_window_flags_icon_format` to avoid a duplicate icon); right = Alt+Tab target (last session), git branch (hidden outside repos), session +N other sessions. Window tabs use catppuccin icon flags (bell, activity, zoom). No clock/battery/CPU: the niri DMS bar shows those.
- Tabs: `@window_label` (status.conf) = program icon (`scripts/window-icon`, falls back to the program name) + folder basename + pane count when split + `@claude_marker`. Used by catppuccin window text and the Alt+s session list (`choose-tree -F`).
- Claude Code state per PANE (several Claude sessions can share a window/session): `~/.claude/hooks/tmux-claude-state.sh` sets pane option `@claude_state` (UserPromptSubmit/PostToolUse → working, Notification → waiting, Stop → done unless the window is visible, SessionEnd → clear). Tabs (`@claude_marker`) show a count per state (state icon, plus the number when >1); the Alt+s picker shows coloured Claude icons instead. Counts come from `#{n:#{P:…}}` formats (`@claude_*_count`). `session-window-changed[10]` / `client-session-changed[10]` run `scripts/claude-clear-done` to acknowledge done panes in the visited window. monitor-activity stays off on a window until its last Claude pane ends.
- Alt+s = `scripts/session-picker` (fzf in a rounded popup): most recent first, current last as "(here)", Claude marker, window icons, live preview; one icon per distinct pane program with a count when >1 (never three copies); Claude panes use the Claude icon itself as the state marker, coloured red waiting / yellow working / green done / dim idle, each with its own count, Enter switch, ctrl-x kill (y/N), unknown name + Enter creates. The binding stores `#{session_id}` in `@picker_origin_session` first.
- Colours: always `#{@thm_*}` tokens from catppuccin, never hex, in status formats.
- `status-right` must keep `#(…/tmux-continuum/scripts/continuum_save.sh)` or continuum autosave stops.
- Prefix is `Alt+Space` (`M-Space`).
- Two-layer keymap direction: `Alt+key` (root table, no prefix) for frequent actions; prefix + mnemonic key for the rest.
- `Alt+Tab` = `scripts/session-history previous`: an MRU queue of session ids in the global option `@session_history`, pushed by `client-session-changed[20]`, pruned by `session-closed[20]`. Alt+Tab jumps to the newest surviving session that isn't the current one, so killing a session falls through to the next one. The status bar target is `@previous_session_name` (not `client_last_session`, which goes stale when that session dies). niri's `Alt+Tab` / `Alt+Shift+Tab` were removed from `~/.config/niri/config.kdl` `recent-windows { binds {} }` so the key reaches tmux.

## Preferences & Rules
- Harpoon is not used; don't reintroduce it or plan around it.
- Keep tmux defaults for prefix splits (`"` below, `%` right) and copy mode (`[`). Don't propose `|`/`-` or `v` replacements.
- Alt+Tab means "go back to the previous session", not cycle through sessions. No Alt+Shift+Tab binding.
- Status bar keeps its background (`@catppuccin_status_background "#{@thm_bg}"`); user tried transparent and asked for the bg back. Popups (tmux-leap etc.) ARE transparent (`popup-style default`).
- Window tabs are left-aligned (`status-justify left`). User hates centred tabs.
- Tab separators and badges put `bg=#{@thm_bg}` behind round glyphs (not `default`), so corners match the bar.
- Killing a session switches to the most recently used session instead of detaching (`detach-on-destroy off`).
- Before adding any `bind -n M-<key>`, check the Alt-key owners below.

## Patterns & Conventions
- Splits and new windows always use `-c "#{pane_current_path}"`.
- Destructive bindings go through `confirm-before`, except closing a pane: Alt+x / prefix x close instantly when the pane is an idle shell and ask only when a program or background job is running (non-shell `pane_current_command`, or the shell has children via `pgrep -P #{pane_pid}`).
- Add `-N "note"` to bindings so `prefix ?` lists readable names.

## Learnings & Corrections
- ❌ Deleting the whole niri `recent-windows { binds { … } }` block → ✅ Keep the block. Leaving it out restores niri's default Alt+Tab and Mod+Tab. Remove individual lines only.
- ❌ Assuming a cycling session switch (`switch-client -n/-p`) → ✅ User wanted previous-session toggle (`switch-client -l`).

- ❌ Running yazi in `display-popup` → quit hangs exactly 5 s (yazi ≥26.9.1 waits for a terminal probe; tmux popups/hidden panes never deliver passthrough replies, upstream issue sxyazi/yazi#4361 closed not-planned). Env vars can't hide tmux (detected via XTVERSION reply). ✅ Open yazi in a visible pane (`split-window -h -Z`): quit is ~6 ms and image previews work.

- ❌ Two `%hidden MODULE_NAME=…` + `source` pairs in one file → only the last module is created (%hidden is resolved when the file is parsed, before commands run). ✅ One module per file under `modules/`.
- ❌ Verifying `#()` job output with `tmux display -p` → always empty (display doesn't wait for jobs). ✅ Attach a pty client to a `-L` test server and read the drawn status line.
- ❌ catppuccin `rounded` window style with a transparent bar → tab corners render as opaque dark squares in kitty (the style draws separators with `reverse`, and kitty only makes default-bg cells transparent). ✅ `custom` window style with `#[fg=<pill colour>,bg=default]` round glyphs in `theme.conf`.
- ❌ Switching themes and only reloading → old theme's `status-bg` / `window-status-style` stay set in the live server, so the bar stays opaque. ✅ `status.conf` explicitly sets `status-style` from `@thm_bg` and resets `window-status-style` / `window-status-current-style` / `popup-style`. `status-bg` overrides `status-style` when not `default`, so never set it.
- ❌ tmux activity alerts on Claude Code windows → always on (its TUI redraws constantly). ✅ Hook script sets `monitor-activity off` per Claude window (SessionStart and every state, unset on SessionEnd), and the tab's new-output icon (`@catppuccin_window_flags_icon_format` in theme.conf) also requires `monitor-activity` on and `pane_current_command != claude`. tmux still sets `window_activity_flag` with monitoring off, so the format check is required.
- ❌ Mapping every Claude `Notification` to waiting → the `idle_prompt` nudge (~60 s after Stop) overwrote done with the question mark. ✅ Notification hook has matcher `permission_prompt|elicitation_dialog`, and the script also ignores other `notification_type`s.
- ❌ Reading `tmux list-sessions` with `IFS=$'\t'` → empty fields (never-attached sessions) collapse and columns shift. ✅ Use `\x1f` as the separator.
- ❌ Detecting the current session inside a popup with `tmux display` or `$TMUX_PANE` → wrong session; popup commands and `-e` aren't format-expanded. ✅ Binding runs `set -gF @picker_origin_session "#{session_id}"` before `display-popup`.

- ❌ `switch-client -l` / `#{client_last_session}` for Alt+Tab → single pointer, dead after that session is killed. ✅ MRU queue in `scripts/session-history`.

- ❌ Storing `@claude_state` as a window option → two Claude panes in one window overwrite each other, and pane-level reads fall through to a stale window value. ✅ Pane option, and unset any leftover window-level `@claude_state` after migrating.

- ❌ `[[ cond ]] && cmd` as the last line of a hook script → exits 1 when cond is false and tmux shows "returned 1" in a message. ✅ Use `if … then … fi` (or end with `exit 0`) in scripts run by `run-shell`.

- Claude icon: Nerd Fonts has no Claude logo, so `scripts/build-claude-glyph` generates a one-glyph font (`U+F6000`) from the real logo outline in `assets/claude-logo.svg` (simple-icons, CC0) into `~/.dotfiles/fonts/.local/share/fonts/claude-glyph/` and links it into `~/.local/share/fonts`. `scripts/window-icon` prints it for `claude`. Rerun the script on a new machine. Kitty must map it explicitly: `symbol_map U+F6000 Claude Glyph` in `~/.config/kitty/kitty.conf` (fontconfig fallback alone rendered a box). Reload kitty with ctrl+shift+f5, or restart it, after changing fonts.

## Dependencies & Tooling
- Plugins: tpm, tmux-sensible, catppuccin/tmux v2.3.1 (official, pinned tag; replaced dreamsofcode-io/catppuccin-tmux 2026-09-29), tmux-continuum, tmux-yank (wl-copy), vim-tmux-navigator, tmux-thumbs (`prefix F`), extrakto (`prefix Tab`).
- `tmux-leap` popup on `Alt+f` (moved off root `C-f` so nvim/less/zsh keep Ctrl+f).
- Validate bindings in isolation: `tmux -L lint -f /dev/null new-session -d \; source-file <file>`.

## Alt-key owners (conflict map)
- **kitty** (eats before tmux): h j k l u d c v - =, Shift+s, Shift+a
- **nvim**: t, i (terminal toggles). Harpoon removed 2026-09-29, so 1–9, a and Shift+h are free.
- **niri**: ` and Shift+` (same-app window switch)
- **tmux**: Tab, 1–9, Shift+h/j/k/l, z n p w b x s g y f (Alt+Enter removed at user request; split right is prefix %)
- **Avoid**: `[` (escape-sequence prefix)

## Current State
- Applied 2026-09-29: full Alt layer, prefix cleanup (confirming kills, reload message, double-tap prefix = last window, prefix Enter menu), vi copy-mode extras. Reference page: https://claude.ai/artifact/8s9FyXM8CX2HHkPMN3TB59
- Removed: `bind -r r`, `bind q kill-window` (unconfirmed), `M-Space send-prefix`, root `C-f`.
