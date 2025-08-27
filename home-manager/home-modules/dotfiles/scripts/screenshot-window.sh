#!/usr/bin/env bash
set -euo pipefail

# Where to save; override with: SCREENSHOT_DIR=/path/to/dir
SCREENSHOT_DIR="${SCREENSHOT_DIR:-"$HOME/Pictures/Screenshots"}"
mkdir -p "$SCREENSHOT_DIR"

# Ensure required tools exist
for cmd in grim satty; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd not found in PATH." >&2; exit 1; }
done

# Timestamped output path
outfile="$SCREENSHOT_DIR/satty-$(date '+%Y%m%d-%H%M%S').png"

# Try to get focused window geometry using different compositor-specific methods
get_window_geometry() {
    # Try Sway first
    if command -v swaymsg >/dev/null 2>&1; then
        local geometry
        geometry=$(swaymsg -t get_tree | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' 2>/dev/null)
        if [[ -n "$geometry" && "$geometry" != "null" ]]; then
            echo "$geometry"
            return 0
        fi
    fi
    
    # Try Hyprland
    if command -v hyprctl >/dev/null 2>&1; then
        local geometry
        geometry=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' 2>/dev/null)
        if [[ -n "$geometry" && "$geometry" != "null" ]]; then
            echo "$geometry"
            return 0
        fi
    fi
    
    # Try River (if riverctl is available)
    if command -v riverctl >/dev/null 2>&1; then
        # River doesn't have a direct way to get window geometry via riverctl
        # We'll fall back to slurp for region selection
        return 1
    fi
    
    # Try Wayfire (if wayfire-msg is available)
    if command -v wayfire-msg >/dev/null 2>&1; then
        # Wayfire doesn't have a direct way to get window geometry
        # We'll fall back to slurp for region selection
        return 1
    fi
    
    # Try Niri (if niri msg is available)
    if command -v niri >/dev/null 2>&1; then
        local geometry
        geometry=$(niri msg windows | jq -r '.[] | select(.focused) | "\(.geometry.x),\(.geometry.y) \(.geometry.width)x\(.geometry.height)"' 2>/dev/null)
        if [[ -n "$geometry" && "$geometry" != "null" ]]; then
            echo "$geometry"
            return 0
        fi
    fi
    
    return 1
}

# Try to capture focused window, fall back to region selection if that fails
if geometry=$(get_window_geometry); then
    # Capture the focused window
    grim -g "$geometry" -t ppm - | satty --filename - --fullscreen --output-filename "$outfile"
else
    # Fall back to region selection if we can't get window geometry
    echo "Could not get focused window geometry, falling back to region selection..."
    if command -v slurp >/dev/null 2>&1; then
        grim -g "$(slurp -d)" -t ppm - | satty --filename - --fullscreen --output-filename "$outfile"
    else
        echo "Error: slurp not found. Cannot perform region selection." >&2
        exit 1
    fi
fi
