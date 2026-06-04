# vim: ft=zsh
# History configuration

HISTFILE=~/.config/zsh/.zsh_history
HISTSIZE=10000
SAVEHIST=20000

setopt hist_expire_dups_first  # Trim duplicates first when the file exceeds HISTSIZE
setopt hist_ignore_dups        # Don't record a command identical to the previous one
setopt hist_ignore_space       # Don't record commands that start with a space
setopt hist_verify             # Expand history but let me confirm before running
setopt share_history           # Share history across running sessions
setopt hist_reduce_blanks      # Strip superfluous whitespace before saving
setopt hist_find_no_dups       # Don't show duplicates while cycling through history
setopt hist_save_no_dups       # Don't write duplicate entries to the history file
setopt extended_history        # Save timestamp and duration with each entry

# Always show the complete history with `history`
alias history="history 0"
