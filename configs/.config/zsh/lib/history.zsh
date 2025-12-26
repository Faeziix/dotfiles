# History Configuration

HISTSIZE=10000                   # Maximum events in internal history
SAVEHIST=10000                   # Maximum events in history file
HISTFILE=~/.config/zsh/.zhistory # History file location

setopt EXTENDED_HISTORY          # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST    # Delete duplicates first when trimming
setopt HIST_FIND_NO_DUPS         # Do not display previously found command
setopt HIST_IGNORE_DUPS          # Do not record duplicated commands
setopt HIST_IGNORE_SPACE         # Do not record commands starting with space
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks
setopt HIST_SAVE_NO_DUPS         # Do not save duplicated commands
setopt HIST_VERIFY               # Do not execute history expansions immediately
setopt INC_APPEND_HISTORY        # Add commands to history immediately
setopt SHARE_HISTORY             # Share history between sessions
