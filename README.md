# README

**Author:** Fortydeux

## Disclaimer and intention:

This is a work-in-progress personal NixOS Flake featuring multiple desktop environments and Wayland compositors. The system includes KDE Plasma, COSMIC Desktop, and five compositors: Hyprland, Niri, Sway, River, and Wayfire - each with customized configurations that attempt to show off each compositor's strengths without customizing them too drastically.

As such, it is mostly intended for personal use, but made public for the sake of sharing and easy reference. 

Feel free to use my setup or any parts of it that you find useful. 

I am still very much learning Nix along with many other things, so please leave feedback for any bugs, better practices, corrections, or appreciation, as indicated. 

...that being said, please don't expect speedy updates or support, as this is just a personal/hobby endeavor.

It is also possible that I may leave this flake in a slightly broken state while I'm working on things (although generally not for long, as I daily drive it), so try it at your own risk.

![Hyprland Screenshot](https://github.com/WhatstheUse/Fortydeux-NixOS-System-Flake/blob/main/media/fortyflake-hyprland-screenshot.png)

### My intention with all of these Window Managers/Compositors was to make reasonably nice, usable configs, without changing too much, so that I (and others with the magic of Nix Flakes) can experience how these WMs operate close-ish to Vanilla, but with some of the basic QOL additions already in place.

### I have also opted to leave most of the config files in their raw format, and write them to the $HOME/.config/ directory using home-manager's home.files function. This makes it easier for myself and others to view and edit easily without the surrounding .nix syntax, and also makes them easier to share to non-Nix machines.

### **Important Note on Configuration Management:**
Most major compositor configurations (Hyprland, River, Sway, Wayfire, Niri) are now managed as Nix modules in `home-manager/home-modules/compositor-configs/`. The original dotfiles for these have been moved to backup files (labeled with "-backup"). **Editing these backup files will have no effect** - you must edit the Nix modules instead. However, many smaller utilities (dunst, mako, ranger, etc.) are still managed as dotfiles. Check `home-manager/home-modules/dotfiles-controller.nix` to see which configurations are managed as Nix modules vs dotfiles.

### **Hyprland Hyprscroller Plugin:**
My Hyprland configuration uses the Hyprscroller plugin by default, which provides a PaperWM-like scrolling behavior that is **NOT** Hyprland's default tiling behavior. If you prefer traditional Hyprland tiling, you should comment out the Hyprscroller plugin in `hyprland-config.nix` and may want to reassign some keybindings accordingly.

### **Multi-Host Architecture:**
This flake supports five different host configurations, each tailored for specific hardware or use cases. The username is abstracted to a single variable in `flake.nix`, making it easy to deploy across multiple machines while maintaining consistent configurations.

## Host Configurations

This flake includes several host configurations, each tailored for specific hardware or use cases:

- **Blacktetra** (Recommended for new users): General-purpose configuration using the Zen kernel, optimized for reasonably specced hardware
- **Blackfin**: Music production optimized with Musnix, real-time kernel, and Firewire audio interface support
- **Archerfish**: Microsoft Surface Book configuration with surface kernel and GitHub Actions for kernel caching
- **Killifish**: Another Microsoft Surface Book variant with surface kernel support
- **Pufferfish**: Barebones configuration for older, underpowered machines using Xanmod kernel

**For new users, I recommend starting with the Blacktetra configuration** to get the most out of this flake without the complexity of specialized hardware configurations.

## Install

With disclaimers and descriptors out of the way, the build instructions would go something like this:

### First you want to have a fresh install of NixOS, or one that you don't mind messing up

### Then go ahead and follow these instructions:

git clone <this-repo> (I am cloning into a new folder called 'fortyflake,' you can change the folder, but will need to change your following commands to suit):
```
git clone https://github.com/WhatstheUse/Fortydeux-NixOS-System-Flake.git ~/fortyflake
```

then cd into Flake directory and generate your hardware-configuration into <flake-dir>/nixos-config/hosts/blacktetra/ /note: you could also copy this from your '/etc/nixos/hardware-configuration.nix'/ (I am managing multiple machines with this flake, and I suggest building "blacktetra" host for most users, unless you are on very specific hardware: archerfish and killifish hosts are tailored to MS Surface Book devices, blackfin is optimized for music production, and pufferfish is for older underpowered machines).
> **Note:** This step is very important! A wrong hardware config can break your system, although with the beauty of NixOS you should still be fine to roll back by booting into your previous build.

```
cd ~/fortyflake

sudo nixos-generate-config --show-hardware-config > nixos-config/hosts/blacktetra/hardware-configuration.nix
```

**Change your username in flake.nix:**
- The username is now abstracted to a single variable in `flake.nix` (line 33)
- **CRITICAL:** If you change the username, you MUST also set a password for the new user, or you will lock yourself out of your system!
- The username change will automatically propagate to all system and home-manager configurations

**IMPORTANT: Setting a Password After Username Change**

When you change the username in `flake.nix`, you create a new user account without a password. You have **two options** to avoid getting locked out:

**Option 1: Set password after first build (Recommended)**
1. Build the system first with your new username
2. After the build completes, set a password for your new user:
   ```bash
   sudo passwd your-new-username
   ```
3. Then build home-manager configuration

**Note: If your-new-username in `flake.nix` is the same as your current username that you set while installing NixOS, you should be fine, since the user already exists on your system - The issue comes from trying to log in to a user account that doesn't have a password already set, but now appears as the only user on the system**

**Option 2: Set password in configuration (Advanced)**
If you want to set the password in the configuration itself, you can add a `hashedPassword` to the user configuration in `nixos-config/system-modules/common-config.nix`:

```nix
users.users.${username} = {
  shell = pkgs.fish;
  isNormalUser = true;
  description = "${builtins.substring 0 1 (lib.toUpper username)}${builtins.substring 1 (builtins.stringLength username) username}";
  # Generate a hashed password with: mkpasswd -m sha-512
  hashedPassword = "$6$your-hashed-password-here";
  extraGroups = [ "networkmanager" "wheel" "video" "audio" "jackaudio" "lp" "surface-control" "uinput" ];
  packages = [ ];
};
```

To generate a hashed password, run: `mkpasswd -m sha-512` and copy the output.

**⚠️ WARNING:** If you don't set a password and try to log in, you will be locked out of your system and will need to boot into emergency mode or your previous build generation to fix it!

*** Once these steps are done, you are ready to build the flake

- First build the system with "nixos-rebuild" and "--flake" option: 

```
cd ~/fortyflake

sudo nixos-rebuild switch --flake .#blacktetra-nixos
```
- Then install home-manager and build the home-manager configuration with the following command:
```
nix run home-manager/master -- switch --flake .#your-new-username@blacktetra-nixos
```

Assuming everything now builds correctly, you should have a very decent system running KDE Plasma Wayland Desktop and COSMIC DE, plus my customized compositor setups with Hyprland, River, Sway, Wayfire, and Niri.

I now daily drive Niri, Sway, and Hyprland equally, so Hyprland is no longer the sole focus. My configurations have become more opinionated as I've tightened up keybindings for consistency across compositors, though due to their different workflows and capabilities, users cannot expect full consistency.

**For new users, I recommend trying Niri first**, as *it provides a heads-up display of important keybindings* when launched, including a keybinding to reference this list at any time. *This is a great way to become accustomed to the keybindings that produce relatively consistent behavior across my compositor configurations*.

For all compositors, you'll find the configurations within `home-manager/home-modules/compositor-configs/`. Check the respective config files to see full keybinding lists and customize your setup.

### Cross-Compositor Keybindings (Mostly Consistent):

**Application Launchers:**
- **CTRL+SPACE**: Fuzzel app launcher (Hyprland, Sway, River, Niri, Wayfire)
- **ALT+SPACE**: Anyrun launcher (Hyprland, Sway, Niri, Wayfire)

**Terminal & System:**
- **SUPER+S**: Launch terminal (kitty/foot) (Hyprland, Sway, River, Niri)
- **SUPER+Q**: Close window (Hyprland, Sway, River, Niri)
- **SUPER+SHIFT+E**: Exit compositor (Sway, River)
- **SUPER+M**: Exit Hyprland

**Window Management:**
- **SUPER+F**: Toggle fullscreen (Hyprland, Sway, River, Niri)
- **SUPER+RETURN**: Toggle float (Sway, River, Niri)
- **SUPER+V**: Toggle float (Hyprland)

**Navigation (Arrow Keys):**
- **SUPER+Arrow Keys**: Focus windows/columns (Hyprland, Sway, River, Niri)
- **SUPER+SHIFT+Arrow Keys**: Move windows/columns (Hyprland, Sway, River, Niri)
- **SUPER+J/K**: Focus windows (Sway, River, Niri)
- **SUPER+SHIFT+J/K**: Move windows (Sway, River, Niri)

**Workspace/Column Management:**
- **SUPER+1-9**: Switch to workspace/column (Hyprland, Sway, River, Niri)
- **SUPER+SHIFT+1-9**: Move window to workspace/column (Hyprland, Sway)
- **SUPER+CTRL+Left/Right**: Switch workspaces (Sway)
- **SUPER+Home/End**: Focus first/last column (Hyprland, Niri)

**Special Features:**
- **SUPER+SHIFT+Slash**: Show hotkey overlay (Niri)
- **SUPER+O**: Toggle overview (Niri)
- **SUPER+Grave**: Toggle overview/switch windows (Niri)

**Voice Dictation (Available in most compositors):**
- **SUPER+X**: Faster-Whisper dictation (momentary)
- **SUPER+SHIFT+X**: WhisperCPP dictation (momentary)
- **SUPER+Backslash**: Faster-Whisper dictation (toggle)
- **SUPER+SHIFT+Backslash**: WhisperCPP dictation (toggle)

### Notes on Compositor Differences:
- **Hyprland**: Flashy and fast tiling compositor - I'm using Hyprscroller plugin for PaperWM-like behavior (see note above)
- **River**: Uses a tag system instead of standard workspaces
- **Niri**: Column-based layout similar to PaperWM
- **Sway**: Traditional i3-style tiling with workspaces
- **Wayfire**: More traditional floating window management, but with some fun Compiz-style tricks up its sleave

Each compositor has its own unique features and capabilities. Check the respective config files in `home-manager/home-modules/compositor-configs/` for complete keybinding lists and customization options.

### Important note about configuration editing within this Flake:
- Most major compositor configurations are now managed as Nix modules in `home-manager/home-modules/compositor-configs/`
- To edit these configurations, you need to modify the Nix files within the flake, then run "home-manager switch" to write the updated files to $HOME
- You may even need to reboot or CTRL+M to quit Hyprland and log back in to see your changes
- This is a MUCH more cumbersome workflow, especially for Hyprland where normally saving hyprland.conf would trigger an automatic reload of the config file, giving immediate feedback of changes
- Smaller utilities (dunst, mako, ranger, etc.) are still managed as dotfiles in `home-manager/home-modules/dotfiles/` - check `dotfiles-controller.nix` to see which configurations are managed as Nix modules vs dotfiles
- Therefore, if you are making a lot of changes, you may want to stop Home-manager from managing these files (comment out and run switch command), and go back to editing them directly within your $HOME directory until most of your edits are done, at which time you may choose to copy them back into the appropriate Nix modules and resume home-manager's management of them

Please contact me with any questions/comments. Thanks! 

Also many **thanks** to all those I've learned from and whose projects I am using as full packages, or just bits of code that I've learned or borrowed.

You all have contributed to my learning journey, and building the most fun and productive desktop/wm environment (for my own needs and preferences) in which I've ever had the pleasure to work.

A totally non-comprehensive list:
- The NixOS team
- The creators, developers, maintainers and contributors to all of the amazing projects that I've incorporated, from desktop environments and compositors down to notification widgets, archiving tools and socket connectors. 
- All the Linux Unplugged/Jupiter Broadcasting guys (and community), who got me started on both NixOS and Hyprland - both decisions I've questioned at times, but ultimately find myself better off
- LibrePhoenix - for some of the best NixOS tutorials for a someone like me... as a nurse by trade rather than a developer, I needed a different approach
- ChatGPT - ...um, yeah. It turns out as a nurse, you don't find many friends who are into Linux, Nix, and Hyprland... so having 'someone' to bug with questions repeatedly at all hours, short of a real-world mentor, is pretty invaluable.
- Too many others to mention on github, matrix, etc, from whom I've learned some valuable Nix and configuration tips and tricks. 
