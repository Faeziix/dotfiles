# Path Configuration

# Ensure path arrays do not contain duplicates
typeset -U path cdpath fpath manpath

# Set default paths
path=(
  $HOME/.local/bin
  $HOME/.scripts
  $path
)

export PATH
