{ config, pkgs, user, ... }: 

{ # Display-manager.nix

  # Enable Cosmic Greeter / Display Manager
  # services.displayManager.cosmic-greeter.enable = true;

  #Enable SDDM Display manager
 services.displayManager = {
    enable = true;
    sddm.enable = true;
    sddm.wayland.enable = true;
    
    # Configure SDDM cursor theme to match Stylix settings
    sddm = { 
      autoNumlock = true;
      settings = {
        Theme = {
          CursorTheme = "phinger-cursors-light";
          CursorSize = "32";
        };
      };
    };
  };

   # Greetd - enable if disabling other login managers 
 #  services.greetd = {
 #    enable = true;
 #  #  settings = {
 #  #    default_session = {
 #  #      command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprConfig}";
 #  #    };
 #  #  };
 #    settings = rec {
 #      initial_session = {
 #        command = "${pkgs.hyprland}/bin/Hyprland";
 #        user = ${user};
 #      };
 #      default_session = initial_session;
 #    };
 #  };	
}
