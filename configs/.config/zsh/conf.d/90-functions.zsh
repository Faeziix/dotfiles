# vim: ft=zsh
# Custom functions

# mkcd — make a directory (and parents) then enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# extract — unpack almost any archive with one command
extract() {
    if [[ -z "$1" ]]; then
        echo "Usage: extract <archive>" >&2
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "extract: '$1' is not a file" >&2
        return 1
    fi
    case "$1" in
        *.tar.bz2|*.tbz2) tar xjf "$1" ;;
        *.tar.gz|*.tgz)   tar xzf "$1" ;;
        *.tar.xz|*.txz)   tar xJf "$1" ;;
        *.tar.zst)        tar --zstd -xf "$1" ;;
        *.tar)            tar xf "$1" ;;
        *.bz2)            bunzip2 "$1" ;;
        *.gz)             gunzip "$1" ;;
        *.xz)             unxz "$1" ;;
        *.zst)            unzstd "$1" ;;
        *.zip)            unzip "$1" ;;
        *.rar)            unrar x "$1" ;;
        *.7z)             7z x "$1" ;;
        *.Z)              uncompress "$1" ;;
        *) echo "extract: don't know how to extract '$1'" >&2; return 1 ;;
    esac
}

# download — yt-dlp for YouTube links, gallery-dl for everything else
download() {
    if [[ $1 =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/ ]]; then
        yt-dlp --format "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" "$@"
    else
        gallery-dl -D . --cookies-from-browser firefox "$@"
    fi
}

# tmux_force — attach to (or create) the '~' tmux session and keep reattaching
tmux_force() {
    if ! command -v tmux >/dev/null 2>&1; then
        echo -e "\033[31mError: tmux is not installed.\033[0m" >&2
        return 1
    fi
    if [ -n "$TMUX" ]; then
        echo -e "\033[31mError: Already in a tmux session.\033[0m" >&2
        return 1
    fi
    if tmux has-session -t '\~' 2>/dev/null; then
        if ! tmux attach-session -t '\~' 2>/dev/null; then
            echo -e "\033[31mError: Failed to attach to tmux session '~'.\033[0m" >&2
            return 1
        fi
    else
        if ! tmux new-session -s '~' -c '~' 2>/dev/null; then
            echo -e "\033[31mError: Failed to create new tmux session '~'.\033[0m" >&2
            return 1
        fi
    fi
    while tmux has-session 2>/dev/null; do
        if ! tmux attach 2>/dev/null; then
            echo -e "\033[31mError: Failed to reattach to tmux.\033[0m" >&2
            return 1
        fi
    done
    return 0
}

# command-not-found handler — suggest the package providing a missing command (pkgfile)
if [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi

# Startup timing helper: set `enable_timing=true` and call `log_time <label>`
enable_timing=false
START_TIME=$(date +%s%N)
log_time() {
  if $enable_timing; then
    local step=$1
    local current_time=$(date +%s%N)
    local elapsed=$(( (current_time - START_TIME) / 1000000 ))  # in milliseconds
    echo "Time taken until $step: ${elapsed} ms"
    START_TIME=$current_time
  fi
}
