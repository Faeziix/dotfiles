#!/bin/bash
# centerify.sh
# Purpose: Centers products in images while maintaining original dimensions
# Usage: 
#   Standalone: ./centerify.sh image1.png image2.jpg
#   With xargs: ls *.png | xargs ./centerify.sh
#   With xargs parallel: ls *.jpg | xargs -P 4 ./centerify.sh

process_image() {
    local file="$1"
    
    # Check if file exists
    if [[ ! -f "$file" ]]; then
        echo "Error: File '$file' not found" >&2
        return 1
    fi
    
    # Get original dimensions
    width=$(identify -format "%w" "$file" 2>/dev/null)
    height=$(identify -format "%h" "$file" 2>/dev/null)
    
    # Check if identify command succeeded
    if [[ -z "$width" || -z "$height" ]]; then
        echo "Error: Could not get dimensions for '$file'" >&2
        return 1
    fi
    
    # Process the image
    magick "$file" \
        -trim +repage \
        -background white \
        -gravity center \
        -extent "${width}x${height}" \
        "centered_$file"
    
    if [[ $? -eq 0 ]]; then
        echo "Processed: $file → centered_$file"
    else
        echo "Error: Failed to process '$file'" >&2
        return 1
    fi
}

# Main logic
if [[ $# -gt 0 ]]; then
    # Standalone mode: process command line arguments
    for file in "$@"; do
        process_image "$file"
    done
else
    # xargs mode: read from stdin
    while IFS= read -r file; do
        process_image "$file"
    done
fi
