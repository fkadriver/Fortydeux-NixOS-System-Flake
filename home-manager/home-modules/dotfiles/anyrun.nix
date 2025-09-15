{ config, lib, pkgs, inputs, ... }:

{
  programs.anyrun = {
    enable = true;
    # package = inputs.anyrun.packages.${pkgs.system}.anyrun;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;
      plugins = [
        "${pkgs.anyrun}/lib/libapplications.so"
        "${pkgs.anyrun}/lib/libsymbols.so"
        "${pkgs.anyrun}/lib/libdictionary.so"
        "${pkgs.anyrun}/lib/libkidex.so"
        "${pkgs.anyrun}/lib/librandr.so"
        "${pkgs.anyrun}/lib/librink.so"
        "${pkgs.anyrun}/lib/libshell.so"
        "${pkgs.anyrun}/lib/libstdin.so"
        "${pkgs.anyrun}/lib/libtranslate.so"
        "${pkgs.anyrun}/lib/libwebsearch.so"
      ];
    };
    extraConfigFiles = {
      "websearch.ron".text = ''
        Config(          
          prefix: "?",
          // Options: Google, Ecosia, Bing, DuckDuckGo, Custom
          //
          // Custom engines can be defined as such:
          // Custom(
          //   name: "Searx",
          //   url: "searx.be/?q={}",
          // )
          //
          // NOTE: `{}` is replaced by the search query and `https://` is automatically added in front.
          engines: [DuckDuckGo]         )
      '';
    };
    extraCss = ''
      #  window {
      #     background-color: transparent;
      #   }

        #search {
          background: ${config.lib.stylix.colors.base00}CC;  # 80% opacity
          border: 2px solid ${config.lib.stylix.colors.base01}CC;
          border-radius: 12px;
          margin: 1em;
          padding: 0.5em;
        }

        #entries {
          background: ${config.lib.stylix.colors.base00};    # opaque
          border: 2px solid ${config.lib.stylix.colors.base01};
          border-radius: 12px;
          margin: 1em;
          margin-top: -1.5em;
        }

        entry {
          color: ${config.lib.stylix.colors.base05};
          font-size: 16pt;
          padding: 0.5em 1em;
        }

        list {
          background: transparent;
        }

        .row {
          background: transparent;
          padding: 0.5em 1em;
        }

        .row:selected {
          background: ${config.lib.stylix.colors.base01};
          border-radius: 8px;
        }
    '';
  };
}
