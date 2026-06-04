# vim: ft=zsh
# Core shell options

setopt autocd               # Change directory just by typing its name
setopt interactivecomments  # Allow comments in interactive mode
setopt magicequalsubst      # Filename expansion for 'anything=expression' arguments
setopt nonomatch            # Hide error if a glob has no match
setopt notify               # Report background job status immediately
setopt numericglobsort      # Sort filenames numerically when sensible
setopt promptsubst          # Enable command substitution in prompt
setopt auto_pushd           # Push visited directories onto the stack
setopt pushd_ignore_dups    # Don't store duplicate directories on the stack
setopt pushd_silent         # Don't print the stack after pushd/popd
setopt EXTENDED_GLOB        # Enable extended globbing

# Treat '/' as a word boundary (so ^W deletes one path segment)
WORDCHARS=${WORDCHARS//\/}
