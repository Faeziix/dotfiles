# Setup fzf
# ---------
if [[ ! "$PATH" == */home/faezix/.config/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/faezix/.config/fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/faezix/.config/fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/home/faezix/.config/fzf/shell/key-bindings.zsh"


# Configurations
# --------------
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,*venv,.bun,cache}"
export FZF_CTRL_T_COMMAND="fd --hidden --follow --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,*venv,.bun,cache}"
export FZF_ALT_C_COMMAND="fd --hidden --follow --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,tmp,*venv,.bun,cache} --type d"

# --margin is TOP,RIGHT,BOTTOM,LEFT — the bottom value adds space under the window
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --cycle --margin=0,0,1,0"
# Preview file contents on Ctrl-T, directory tree on Alt-C
export FZF_CTRL_T_OPTS="--preview '[[ -d {} ]] && lsd -1 --color=always {} || bat --color=always --line-range :200 {}'"
export FZF_ALT_C_OPTS="--preview 'lsd -1 --color=always {}'"

# Functions
# ---------

