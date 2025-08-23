{ config, pkgs, ... }:

{
  imports = [
    ./whisper-dictation/whisper-faster.nix
    ./whisper-dictation/whisper-cpp.nix
    ./whisper-dictation/whisper-plasma.nix
  ];
  services = {
    dictation-faster = {
        enable = true;
        model = "tiny";       # Toggle model here
        language = "en";
        device = "cpu";       # set "cuda" if you have NVIDIA + CUDA set up
    };

    dictation-whispercpp = {
        enable = true;
        model = "small";      # Toggle model here
        language = "en";
    };

    dictation-plasma = {
      enable = true;
      enableFasterWhisper = true;
      enableWhisperCpp = true; 
    };
    
  };
}
