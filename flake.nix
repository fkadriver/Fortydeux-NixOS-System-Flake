{
  description = "Fortydeux NixOS System and Home-manager Flake";

# Flake.nix

  inputs = {  
    # Determinate, Nix, and HM
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2505"; # 25.05 from Flakehub
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0"; # Unstable from Flakehub
  	# nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Unstable from NixOS
    # home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.1";
  	home-manager.url = "github:nix-community/home-manager";
  	# home-manager.url = "github:nix-community/home-manager";
  	home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # Other Projects
    # Anyrun launcher
    anyrun.url = "github:anyrun-org/anyrun";
    # Stylix theming
    stylix.url = "https://flakehub.com/f/danth/stylix/0.1";
    # stylix.url = "github:danth/stylix";
    # Niri compositor
    niri.url = "github:YaLTeR/niri";
    # Hyprland compositor + Plugins
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprscroller = {
      url = "github:cpiber/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };
    hyprgrass = {
       url = "github:horriblename/hyprgrass";
       inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };  
    #MusNix
    musnix.url = "github:musnix/musnix";
  };
  
  outputs = { self, nixpkgs, home-manager, nixos-hardware, niri, stylix, determinate, hyprland, hyprgrass, hyprland-plugins, musnix, ... }@inputs: 
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {    
      nixosConfigurations = {
        #--Archerfish host--#
      	archerfish-nixos = lib.nixosSystem {
    	  	inherit system;
    	  	modules = [ 
    	  	  ./nixos-config/hosts/archerfish/configuration.nix 
          ];
          specialArgs = { inherit inputs; };
      	};
        #--Killifish host--#
      	killifish-nixos = lib.nixosSystem {
    	  	inherit system;
    	  	modules = [ 
    	  	  ./nixos-config/hosts/killifish/configuration.nix 
          ];
          specialArgs = { inherit inputs; };
      	};
        #--Pufferfish host--#
      	pufferfish-nixos = lib.nixosSystem {
    	  	inherit system;
    	  	modules = [ 
    	  	  ./nixos-config/hosts/pufferfish/configuration.nix 
          ];
          specialArgs = { inherit inputs; };
      	};
        #--Blackfin host--#
      	blackfin-nixos = lib.nixosSystem {
    	  	inherit system;
    	  	modules = [ 
    	  	  ./nixos-config/hosts/blackfin/configuration.nix 
            ];
          specialArgs = { inherit inputs; };
      	};
        #--Blacktetra host--#
        blacktetra-nixos = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./nixos-config/hosts/blacktetra/configuration.nix 
          ];
          specialArgs = { inherit inputs; };
        }; 

      };

      ##--Home-Manager Configuration--##     
      homeConfigurations = {
        #--Archerfish host--#
        "fortydeux@archerfish-nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
    	    modules = [
            ./home-manager/hosts/archerfish-home.nix
          ];
        }; 
         #--Killifish host--#
        "fortydeux@killifish-nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
    	    modules = [
            ./home-manager/hosts/killifish-home.nix
          ];
        }; 
         #--Pufferfish host--#
        "fortydeux@pufferfish-nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
    	    modules = [
            ./home-manager/hosts/pufferfish-home.nix
          ];
        }; 
         #--Blackfin host--#
        "fortydeux@blackfin-nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
    	    modules = [
            ./home-manager/hosts/blackfin-home.nix
          ];
        };
         #--Blacktetra host--#
        "fortydeux@blacktetra-nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home-manager/hosts/blacktetra-home.nix
          ];
        }; 
      }; 
   }; 
} 
