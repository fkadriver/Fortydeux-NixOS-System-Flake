#!/usr/bin/env bash
set -euo pipefail

SCREENSHOT_DIR="${SCREENSHOT_DIR:-"$HOME/Pictures/Screenshots"}"
mkdir -p "$SCREENSHOT_DIR"

for cmd in grim satty; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found in PATH." >&2; exit 1; }
done

outfile="$SCREENSHOT_DIR/satty-$(date '+%Y%m%d-%H%M%S').png"

# Full desktop capture (all outputs), pipe to Satty
grim -t ppm - \
  | satty --filename - --fullscreen --output-filename "$outfile"
