{ config, lib, pkgs, ... }:

{
  services.mako = {
    enable = true;
    
    settings = {
      # Basic configuration
      sort = "-priority";
      
      # Mouse actions
      "on-button-left" = "invoke-default-action";
      "on-button-right" = "dismiss";
      "on-button-middle" = "dismiss-all";
      
      # Appearance
      layer = "overlay";
      font = lib.mkForce "Inter Nerd Font 12";  # Override Stylix font
      icons = "1";
      
      # Colors - let Stylix manage theming automatically
      # "background-color" = "#${lib.removePrefix "#" config.lib.stylix.colors.base00}FE";
      # "border-color" = "#${lib.removePrefix "#" config.lib.stylix.colors.base01}FE";
      "border-radius" = "10";
      
      # Layout
      "group-by" = "category";
      margin = "20, 20, 20, 20";
      padding = "10";
      "default-timeout" = "8000";
      
      # Do not disturb mode
      "mode=do-not-disturb" = {
        invisible = "1";
      };
    };
  };
}
