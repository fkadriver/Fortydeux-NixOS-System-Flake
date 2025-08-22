{ config, ... }:

{ # archerfish-home.nix

  imports = [
    ../home-modules/home-commonConfig.nix
    ../home-modules/screen-recording.nix
    ../home-modules/sh-env.nix	
    ../home-modules/dotfiles.nix
    ../home-modules/theming.nix 
    ../home-modules/hyprland-config.nix
    ../home-modules/highdpi-hyprland.nix
    ../home-modules/niri-config.nix
  ];

}
