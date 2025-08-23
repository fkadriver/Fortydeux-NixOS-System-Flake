#!/usr/bin/env bash

# =============================================================================
# Multi-Monitor Setup for Wayfire - Intelligent Display Configuration
# =============================================================================
#
# This script automatically configures displays across different systems:
# - System 1: DP-1 = LG Ultrawide (3440x1440)
# - System 2: DP-1 = Standard monitor (1920x1080)
#
# The script detects display properties and applies appropriate configurations:
# - Laptop display (eDP-1): Auto mode with intelligent scaling
# - External displays: Model-specific or fallback configurations
#
# Usage:
#   ./fix-resolution.sh          # Apply configuration
#   ./fix-resolution.sh test     # Test detection only
#   ./fix-resolution.sh status   # Show current status
#
# =============================================================================

# Function to get display model
get_display_model() {
    local output=$1
    wlr-randr --json | jq -r ".[] | select(.name==\"$output\") | .make + \" \" + .model" 2>/dev/null || echo "Unknown"
}

# Function to get display modes
get_display_modes() {
    local output=$1
    wlr-randr --json | jq -r ".[] | select(.name==\"$output\") | .modes[] | .width + \"x\" + .height" 2>/dev/null
}

# Function to configure laptop display with intelligent scaling
configure_laptop_display() {
    echo "Configuring laptop display (eDP-1)..."
    
    # Get current resolution
    resolution_width=$(wlr-randr --json | jq -r '.[] | select(.name=="eDP-1") | .modes[] | select(.current==true) | .width' 2>/dev/null)
    
    if [ -n "$resolution_width" ] && [ "$resolution_width" != "null" ]; then
        # Set scale based on resolution
        if [ "$resolution_width" -gt 1920 ] && [ "$resolution_width" -le 2880 ]; then
            scale=1.5
        elif [ "$resolution_width" -gt 2880 ]; then
            scale=2.0
        else
            scale=1.0
        fi
        
        echo "  Detected resolution: ${resolution_width}px, setting scale to ${scale}x"
        wlr-randr --output eDP-1 --pos 0,0 --scale $scale
    else
        echo "  eDP-1 not detected or no current mode"
    fi
}

# Function to configure external displays
configure_external_displays() {
    echo "Configuring external displays..."
    
    # Configure DP-1 based on detected model/resolution
    if wlr-randr --json | jq -e '.[] | select(.name=="DP-1")' >/dev/null 2>&1; then
        DP1_MODEL=$(get_display_model "DP-1")
        echo "  DP-1 detected: $DP1_MODEL"
        
        # Check if it's the LG Ultrawide
        if echo "$DP1_MODEL" | grep -q "LG ULTRAWIDE"; then
            echo "  → Configuring as LG Ultrawide (3440x1440@159.962006)"
            wlr-randr --output DP-1 --mode 3440x1440@159.962006 --pos 1620,0 --scale 1.0
            
            # Configure HDMI-A-1 if present (only with ultrawide setup)
            if wlr-randr --json | jq -e '.[] | select(.name=="HDMI-A-1")' >/dev/null 2>&1; then
                echo "  → Configuring HDMI-A-1 (ASUS VS228) to 1920x1080@60.000000"
                wlr-randr --output HDMI-A-1 --mode 1920x1080@60.000000 --pos 5060,0 --scale 1.0
            fi
        else
            # Check if it supports 1920x1080
            if get_display_modes "DP-1" | grep -q "1920x1080"; then
                echo "  → Configuring as standard display (1920x1080@60.000000)"
                wlr-randr --output DP-1 --mode 1920x1080@60.000000 --pos 1620,0 --scale 1.0
            else
                echo "  → Configuring with auto mode"
                wlr-randr --output DP-1 --mode auto --pos 1620,0 --scale 1.0
            fi
        fi
    else
        echo "  DP-1 not detected"
    fi
}

# Function to show current status
show_status() {
    echo "=== Current Display Configuration ==="
    wlr-randr
    echo ""
    echo "=== Detection Analysis ==="
    
    if wlr-randr --json | jq -e '.[] | select(.name=="DP-1")' >/dev/null 2>&1; then
        DP1_MODEL=$(get_display_model "DP-1")
        echo "DP-1: $DP1_MODEL"
        
        if echo "$DP1_MODEL" | grep -q "LG ULTRAWIDE"; then
            echo "  → Will be configured as LG Ultrawide (3440x1440)"
        else
            echo "  → Will be configured as standard display (1920x1080)"
        fi
    else
        echo "DP-1: Not detected"
    fi
}

# Function to test detection only
test_detection() {
    echo "=== Multi-Monitor Detection Test ==="
    echo ""
    
    # Check required tools
    if ! command -v wlr-randr &> /dev/null; then
        echo "❌ wlr-randr not found. Requires Wayland/Wayfire environment."
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo "❌ jq not found. Please install jq for JSON parsing."
        exit 1
    fi
    
    echo "✅ Required tools found"
    echo ""
    
    # Show detected displays
    echo "=== Detected Displays ==="
    wlr-randr --json | jq -r '.[] | "\(.name): \(.make) \(.model) (\(.serial))"' 2>/dev/null || echo "Failed to get display info"
    echo ""
    
    # Analyze DP-1
    echo "=== DP-1 Analysis ==="
    if wlr-randr --json | jq -e '.[] | select(.name=="DP-1")' >/dev/null 2>&1; then
        DP1_MODEL=$(get_display_model "DP-1")
        echo "✅ DP-1 detected: $DP1_MODEL"
        
        if echo "$DP1_MODEL" | grep -q "LG ULTRAWIDE"; then
            echo "🎯 Will configure as LG Ultrawide (3440x1440)"
        else
            echo "🎯 Will configure as standard display (1920x1080)"
        fi
    else
        echo "❌ DP-1 not detected"
    fi
    
    echo ""
    echo "=== Test Complete ==="
}

# Main execution
main() {
    case "${1:-}" in
        "test")
            test_detection
            ;;
        "status")
            show_status
            ;;
        *)
            echo "Configuring multi-monitor setup..."
            echo ""
            
            # Wait a moment for displays to be detected
            sleep 1
            
            configure_laptop_display
            echo ""
            configure_external_displays
            echo ""
            
            echo "Multi-monitor setup complete!"
            echo "Current configuration:"
            wlr-randr
            ;;
    esac
}

# Run main function with all arguments
main "$@"
