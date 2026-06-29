#!/usr/bin/env bash
# ocr.sh — select a screen region, OCR it, then review/edit the text in your
# editor (Vim/Neovim) before copying. Save+quit copies the buffer.
#
#   ocr.sh            # edit in $EDITOR (vim/nvim) in a floating terminal
#   ocr.sh --zenity   # edit in a zenity popup instead
#   OCR_LANG=afr ocr.sh
#
# Wayland: grim + slurp + tesseract + wl-copy (+ a terminal / zenity).

set -euo pipefail

lang="${OCR_LANG:-eng}"
ui="editor"
[ "${1:-}" = "--zenity" ] && ui="zenity"

die() {
	zenity --error --no-wrap --text="OCR: $1" 2>/dev/null ||
		notify-send -u critical "OCR" "$1" 2>/dev/null || true
	echo "ocr: $1" >&2
	exit 1
}

for dep in grim slurp tesseract wl-copy; do
	command -v "$dep" >/dev/null || die "missing dependency: $dep"
done

if ! tesseract --list-langs 2>/dev/null | grep -qx "$lang"; then
	die "tesseract language '$lang' not installed (try: sudo pacman -S tesseract-data-$lang)"
fi

region=$(slurp) || exit 0

image=$(mktemp --suffix=.png)
textfile=$(mktemp --suffix=.txt)
trap 'rm -f "$image" "$textfile"' EXIT

grim -g "$region" "$image"

tesseract "$image" - -l "$lang" 2>/dev/null | sed -e 's/[[:space:]]*$//' >"$textfile"
[ -s "$textfile" ] || die "no text detected"

if [ "$ui" = "zenity" ]; then
	command -v zenity >/dev/null || die "zenity not installed"
	edited=$(zenity --text-info --editable --filename="$textfile" \
		--title="OCR — review & copy" --width=600 --height=400 \
		--ok-label="Copy" --cancel-label="Cancel" 2>/dev/null) || exit 0
	printf '%s' "$edited" | wl-copy
else
	editor="${EDITOR:-${VISUAL:-vim}}"
	# Prefer $TERMINAL, then known terminals. Must block until its window closes.
	term=""
	for t in "${TERMINAL:-}" foot kitty alacritty; do
		[ -n "$t" ] && command -v "$t" >/dev/null && {
			term="$t"
			break
		}
	done
	[ -n "$term" ] || die "no terminal found (set \$TERMINAL or install foot/kitty/alacritty)"
	case "$(basename "$term")" in
	foot) "$term" "$editor" "$textfile" ;;
	kitty) "$term" --class ocr-edit "$editor" "$textfile" ;;
	alacritty) "$term" --class ocr-edit -e "$editor" "$textfile" ;;
	*) "$term" -e "$editor" "$textfile" ;;
	esac
	wl-copy <"$textfile"
fi

chars=$(wc -c <"$textfile" | tr -d ' ')
notify-send "OCR" "Copied ${chars} chars to clipboard" 2>/dev/null || true
