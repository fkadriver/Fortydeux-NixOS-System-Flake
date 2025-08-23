{ config, pkgs, ... }:

{
  imports = [
    ./compositor-configs/hyprland-config.nix
    ./compositor-configs/niri-config.nix
    ./compositor-configs/wayfire-config.nix
    ./compositor-configs/sway-config.nix
    ./compositor-configs/river-config.nix
  ];

  # Enable the compositor modules
  programs.wayfire = {
    enable = true;
    enableStylix = true;
  };

  programs.sway = {
    enable = true;
    enableStylix = true;
  };

  programs.river = {
    enable = true;
    enableStylix = true;
  };

  home.packages = (with pkgs; [
    # kdePackages.yakuake #Drop-down terminal
  ]);
  
  wayland.windowManager = {
    labwc = {
      enable = true;
      menu = [
        {
          menuId = "root-menu";
          label = "";
          icon = "";
          items = [
            {
              label = "BeMenu";
              action = {
                name = "Execute";
                command = "bemenu-run";
              };
            }
            {
              label = "Reconfigure";
              action = {
                name = "Reconfigure";
              };
            }
            {
              label = "Exit";
              action = {
                name = "Exit";
              };
            }
            
          ];
        }
      ];      
    };
  };



  services.stalonetray = {
    enable = true;
    config = {
      icon_size = 100;
    };
  };

}
