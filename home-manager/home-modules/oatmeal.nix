{ config, pkgs, inputs, username, ... }:

let
  # Oatmeal package definition from dustinblackman's NUR repository
  oatmeal = pkgs.stdenv.mkDerivation {
    pname = "oatmeal";
    version = "0.13.0";
    
    src = pkgs.fetchurl {
      url = "https://github.com/dustinblackman/oatmeal/releases/download/v0.13.0/oatmeal_0.13.0_linux_amd64.tar.gz";
      sha256 = "1916ff99559ibkx1k3fb7xc4617plqfaiqypqlrwg31s440mcnfw";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ pkgs.installShellFiles ];

    installPhase = ''
      mkdir -p $out/bin
      cp -vr ./oatmeal $out/bin/oatmeal
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/oatmeal
      mkdir -p $out/share/doc/oatmeal/copyright
      cp LICENSE $out/share/doc/oatmeal/copyright/
      cp THIRDPARTY.html $out/share/doc/oatmeal/copyright/
      installManPage ./manpages/oatmeal.1.gz
      installShellCompletion ./completions/*
    '';

    meta = {
      description = "Terminal UI to chat with large language models (LLM) using backends such as Ollama, and direct integrations with your favourite editor like Neovim!";
      homepage = "https://github.com/dustinblackman/oatmeal";
      license = pkgs.lib.licenses.mit;
      sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
      platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    };
  };
in
{
  home.packages = [ oatmeal ];
}
