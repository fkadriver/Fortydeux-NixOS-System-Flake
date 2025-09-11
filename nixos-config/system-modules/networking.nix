{ config, pkgs, inputs, username, ... }:

{ # Networking.nix

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Tailscale    
  # services.tailscale = {
  #   enable = true;
  #   openFirewall = true;
  # }; 

  # Packages
  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    openvpn
  ];  
  
  # Services - Syncthing
  services.syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "/home/${username}";    # Default folder for new synced folders
      configDir = "/home/${username}/.config/syncthing";   # Folder for Syncthing's settings and keys
  };

}
