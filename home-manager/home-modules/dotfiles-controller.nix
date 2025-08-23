{config, username ? "fortydeux", ... }:

{ ## dotfiles.nix


  # Enable & Configure i3status-rust
  programs.i3status-rust = {
  	enable = true;
  	bars = {
 
  		     default = {
  		          blocks = [
  		             {  		             
  		                block = "cpu";
  		                info_cpu = 20;
  		                warning_cpu = 50;
  		                critical_cpu = 90;
  		             }
  		             {
  		                block = "time";
  		                interval = 5;
  		                format = " $timestamp.datetime(f:'%a %m/%d %R') ";
  		             }
  		             {  		            
  		                block = "disk_space";
  		                path = "/";
  		                info_type = "available";
  		                alert_unit = "GB";
  		                interval = 20;
  		                warning = 20.0;
  		                alert = 10.0;
  		                format = " $icon root: $available.eng(w:2) ";
  		             }
  		             {  		             
  		                block = "memory";
  		                format = " $icon $mem_total_used_percents.eng(w:2) ";
  		                format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
  		             }
  		             {  		             
  		                block = "sound";
  		             }
  		             {
  		             block = "backlight";
  		              missing_format = "";
		               }
                   {
  		                block = "net";
  		             }
  		             {
  		             	block = "battery";
  		             	format = " $icon $percentage ";
  		             	missing_format = "";
  		             }

  		          ];
  		          settings = {
  		              invert_scrolling = true;
  		              theme =  {
  		                theme = "solarized-dark";
  		                overrides = {
  		                  idle_bg = "#123456";
  		                  idle_fg = "#abcdef";
  		                };
  		              };
  		            };
  		            icons = "awesome4";
  		            theme = "solarized-dark";
  		        };
    };
  };



  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/dunst" = {
    	source = ./dotfiles/dunst;
        recursive = true;
    };
    ".config/foot" = {
    	source = ./dotfiles/foot;
    	recursive = true;
    };
    ".config/hypr/hypridle.conf" = {
    	source = ./dotfiles/hypr/hypridle.conf;
    };
    ".config/hypr/hyprlock.conf" = {
    	text = ''
        # Hyprlock.conf

        background {
            monitor =
            path = /home/${username}/.config/wallpapers/sleeping-hammock.webp   # only png supported for now
            color = rgba(25, 20, 20, 1.0)

            # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
            blur_passes = 1 # 0 disables blurring
            blur_size = 7
            noise = 0.0117
            contrast = 0.8916
            brightness = 0.8172
            vibrancy = 0.1696
            vibrancy_darkness = 0.0
        }

        input-field {
            monitor =
            size = 300, 60
            outline_thickness = 3
            dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = false
            dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
            outer_color = rgb(151515)
            inner_color = rgb(200, 200, 200)
            font_color = rgb(10, 10, 10)
            fade_on_empty = true
            fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
            placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
            hide_input = false
            rounding = -1 # -1 means complete rounding (circle/oval)

            position = 0, -20
            halign = center
            valign = center
        }

        label {
            monitor =
            text = cmd[update:1000] echo "<span foreground='##ffffff'>$(date)</span>"
            color = rgba(200, 200, 200, 1.0)
            font_size = 38
            font_family = Noto Sans

            position = 0, 80
            halign = center
            valign = center
        }
      '';
    };
    ".config/i3bar-river" = {
    	source = ./dotfiles/i3bar-river;
    	recursive = true;
    };
    ".config/kitty" = {
    	source = ./dotfiles/kitty;
    	recursive = true;
    };
    ".config/logos" = {
    	source = ./dotfiles/logos;
    	recursive = true;
    };
    ".config/mako" = {
    	source = ./dotfiles/mako;
    	recursive = true;
    };
    ".config/micro" = {
    	source = ./dotfiles/micro;
    	recursive = true;
    }; 
		".config/miracle-wm" = {
    	source = ./dotfiles/miracle-wm;
    	recursive = true;
    }; 
    # Still write waybar config files for niri
    ".config/niri/waybar" = {
    	source = ./dotfiles/niri/waybar;
    	recursive = true;
    };
    ".config/nvim" = {
    	source = ./dotfiles/nvim;
    	recursive = true;
    }; 
    ".config/ranger" = {
    	source = ./dotfiles/ranger;
    	recursive = true;
    }; 
    ".config/river/scripts" = {
      source = ./dotfiles/river/scripts;
      recursive = true;
    };
    ".config/scripts" = {
    	source = ./dotfiles/scripts;
    	recursive = true;
    };
    ".config/sway/scripts" = {
      source = ./dotfiles/sway/scripts;
      recursive = true;
    };
    # Wallpapers for general use    
    ".config/wallpapers" = {
    	source = ./dotfiles/wallpapers;
    	recursive = true;
    };
	};
}
