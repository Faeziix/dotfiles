# Tmux Force Function

# Force a command to run in tmux
tmux_force() {
  # If not running in tmux
  if [[ -z "$TMUX" ]]; then
    # If tmux is running, attach to it
    if tmux has-session 2>/dev/null; then
      tmux attach
    else
      # Otherwise start a new session
      tmux new-session
    fi
  fi
}
