#!/usr/bin/env bash
set -euo pipefail

# Where to save; override with: SCREENSHOT_DIR=/path/to/dir
SCREENSHOT_DIR="${SCREENSHOT_DIR:-"$HOME/Pictures/Screenshots"}"
mkdir -p "$SCREENSHOT_DIR"

# Ensure required tools exist
for cmd in grim slurp satty; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found in PATH." >&2; exit 1; }
done

# Timestamped output path
outfile="$SCREENSHOT_DIR/satty-$(date '+%Y%m%d-%H%M%S').png"

# Let the user drag a region (output-aware), capture as PPM, pipe to Satty
grim -g "$(slurp -d)" -t ppm - \
  | satty --filename - --fullscreen --output-filename "$outfile"
