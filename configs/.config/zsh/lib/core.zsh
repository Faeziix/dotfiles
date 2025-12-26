# ZSH Core Configuration

# Path to your oh-my-zsh installation
ZSH=/usr/share/oh-my-zsh/

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Basic ZSH settings
setopt AUTO_CD              # If a command is not recognized and is a directory, cd to it
setopt EXTENDED_GLOB        # Extended globbing
setopt INTERACTIVE_COMMENTS # Allow comments in interactive shells
setopt NO_CASE_GLOB         # Case insensitive globbing
setopt NUMERIC_GLOB_SORT    # Sort filenames numerically
setopt PROMPT_SUBST         # Enable parameter expansion in prompts
