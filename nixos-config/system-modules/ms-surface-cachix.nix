{ config, pkgs, lib, username, ... }:

{
  # MS-Surface Cachix helper module
  # This module provides a script to rebuild NixOS with Cachix credentials
  # to avoid the chicken-and-egg problem where the kernel needs to be built
  # before the Cachix configuration is available.

  # Create a system-wide command for rebuilding with Surface kernel Cachix cache
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "rebuild-with-surface-cache" ''
      #!/usr/bin/env bash
      # Rebuild NixOS with Surface kernel Cachix credentials
      # This script ensures the Cachix cache is available during the rebuild process
      
      set -euo pipefail
      
      # Colors for output
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[1;33m'
      BLUE='\033[0;34m'
      NC='\033[0m' # No Color
      
      echo -e "''${BLUE}🔧 Rebuilding NixOS with Surface kernel Cachix cache...''${NC}"
      echo -e "''${YELLOW}This will use the pre-built Surface kernel from Cachix instead of building locally.''${NC}"
      echo ""
      
      # Get the current hostname to determine the correct flake target
      HOSTNAME=$(hostname)
      FLAKE_TARGET=""
      
      case "$HOSTNAME" in
        "archerfish-nixos")
          FLAKE_TARGET="archerfish-nixos"
          ;;
        "killifish-nixos")
          FLAKE_TARGET="killifish-nixos"
          ;;
        *)
          echo -e "''${RED}❌ Unknown hostname: $HOSTNAME''${NC}"
          echo -e "''${YELLOW}Please specify the flake target manually:''${NC}"
          echo -e "''${YELLOW}Usage: $0 <flake-target>''${NC}"
          echo -e "''${YELLOW}Available targets: archerfish-nixos, killifish-nixos''${NC}"
          if [ $# -eq 0 ]; then
            exit 1
          else
            FLAKE_TARGET="$1"
          fi
          ;;
      esac
      
      echo -e "''${BLUE}📦 Using flake target: $FLAKE_TARGET''${NC}"
      echo ""
      
      # Run nixos-rebuild with Cachix credentials
      echo -e "''${GREEN}🚀 Starting rebuild with Cachix credentials...''${NC}"
      sudo nixos-rebuild switch \
        --flake ".#$FLAKE_TARGET" \
        --option substituters "https://cache.nixos.org https://fortydeux-surface.cachix.org" \
        --option trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= fortydeux-surface.cachix.org-1:FFouI4YY62YGdnQbABdRu+jGfhMDnO+zNWGocIFd3rs="
      
      echo ""
      echo -e "''${GREEN}✅ Rebuild completed successfully!''${NC}"
      echo -e "''${BLUE}🎉 Your Surface kernel should now be using the cached version from Cachix.''${NC}"
    '')
  ];
}
