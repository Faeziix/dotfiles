# vim: ft=zsh
# Prompt

# Pin the prompt to the bottom row of the terminal before each redraw
autoload -Uz add-zsh-hook
function bottom_prompt {
  tput cup $(($LINES-1)) 0
}
add-zsh-hook precmd bottom_prompt

# Starship prompt
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship-prompt/starship.toml
