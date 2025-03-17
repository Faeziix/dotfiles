#!/bin/bash
# center-images.sh
# Purpose: Centers products in images while maintaining original dimensions
# Usage: ls *.png | ./center-images.sh
#   or: find . -name "*.png" | ./center-images.sh

# Process each image file piped into the script
xargs -I {} bash -c '
  # Get original dimensions
  width=$(identify -format "%w" "{}")
  height=$(identify -format "%h" "{}")
  
  # Process the image:
  # 1. Add a white border (to ensure trim works with edge-touching objects)
  # 2. Trim excess whitespace to get just the product
  # 3. Center the product on a white canvas of original dimensions
  convert "{}" \
    -bordercolor white -border 1x1 \
    -trim +repage \
    -gravity center \
    -background white \
    -extent ${width}x${height} \
    "centered_{}"
  
  echo "Processed: {} → centered_{}"
' 

# Add a usage example if no input is provided
if [ -t 0 ]; then
  echo "Usage: ls *.png | $0"
  echo "   or: find . -name \"*.png\" | $0"
  echo "   or: echo \"image1.png image2.png\" | xargs -n1 | $0"
fi

# To use in parallel (uncomment the line below and comment the first xargs line):
# xargs -P 4 -I {} bash -c '...'
