{ config, ... }:

{ # pufferfish-home.nix

  imports = [
    ../home-modules/home-commonConfig.nix
    ../home-modules/sh-env.nix	
    ../home-modules/dotfiles-controller.nix
    ../home-modules/home-theme.nix 
    # ../home-modules/wm-homeController.nix
    # Task-specific
    ../home-modules/whisper-controller.nix
    # ../home-modules/screen-recording.nix
  ];

}
