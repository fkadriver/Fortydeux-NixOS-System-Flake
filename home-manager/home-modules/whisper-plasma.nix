{ config, lib, pkgs, ... }:
let
  # Wrapper scripts that use the original daemons but output via ydotool
  dictate-fw-ptt-stop-plasma = pkgs.writeShellScriptBin "dictate-fw-ptt-stop-plasma" ''
    SOCKET="/tmp/faster-whisper-daemon.sock"
    
    # Check if daemon is running and responsive
    if [ ! -S "$SOCKET" ] || ! echo "status" | ${pkgs.socat}/bin/socat -T 2 - UNIX-CONNECT:"$SOCKET" >/dev/null 2>&1; then
      echo "Faster-whisper daemon not responsive" >&2
      exit 1
    fi
    
    # Send stop command and get transcription result (with timeout)
    TEXT="$(echo "stop" | ${pkgs.socat}/bin/socat -T 30 -t 30 - UNIX-CONNECT:"$SOCKET" | head -1)"
    
    # Type the result using ydotool instead of wtype
    if [ -n "$TEXT" ] && [ "$TEXT" != "ok" ] && [ "$TEXT" != "no_result" ]; then
      ${pkgs.ydotool}/bin/ydotool type -- "$TEXT"
    fi
  '';

  dictate-wc-ptt-stop-plasma = pkgs.writeShellScriptBin "dictate-wc-ptt-stop-plasma" ''
    SOCKET="/tmp/whisper-cpp-daemon.sock"
    
    # Check if daemon is running and responsive
    if [ ! -S "$SOCKET" ] || ! echo "status" | ${pkgs.socat}/bin/socat -T 2 - UNIX-CONNECT:"$SOCKET" >/dev/null 2>&1; then
      echo "Whisper-cpp daemon not responsive" >&2
      exit 1
    fi
    
    # Send stop command and get transcription result (with timeout)
    TEXT="$(echo "stop" | ${pkgs.socat}/bin/socat -T 30 -t 30 - UNIX-CONNECT:"$SOCKET" | head -1)"
    
    # Type the result using ydotool instead of wtype
    if [ -n "$TEXT" ] && [ "$TEXT" != "ok" ] && [ "$TEXT" != "no_result" ]; then
      ${pkgs.ydotool}/bin/ydotool type -- "$TEXT"
    fi
  '';

  # Wrapper toggle scripts that use the original start scripts but plasma stop scripts
  dictate-fw-ptt-toggle-plasma = pkgs.writeShellScriptBin "dictate-fw-ptt-toggle-plasma" ''
    SOCKET="/tmp/faster-whisper-daemon.sock"
    
    # Check daemon status
    if [ -S "$SOCKET" ]; then
      STATUS="$(echo "status" | ${pkgs.socat}/bin/socat -T 2 - UNIX-CONNECT:"$SOCKET" 2>/dev/null || echo "idle")"
      if [[ "$STATUS" == *"recording"* ]]; then
        # Currently recording, so stop with plasma version
        ${dictate-fw-ptt-stop-plasma}/bin/dictate-fw-ptt-stop-plasma
      else
        # Not recording, so start with original script
        dictate-fw-ptt-start 2>/dev/null || {
          echo "Original dictate-fw-ptt-start not found. Enable services.dictation-faster first." >&2
          exit 1
        }
      fi
    else
      # Daemon not running, start recording with original script
      dictate-fw-ptt-start 2>/dev/null || {
        echo "Original dictate-fw-ptt-start not found. Enable services.dictation-faster first." >&2
        exit 1
      }
    fi
  '';

  dictate-wc-ptt-toggle-plasma = pkgs.writeShellScriptBin "dictate-wc-ptt-toggle-plasma" ''
    SOCKET="/tmp/whisper-cpp-daemon.sock"
    
    # Check daemon status
    if [ -S "$SOCKET" ]; then
      STATUS="$(echo "status" | ${pkgs.socat}/bin/socat -T 2 - UNIX-CONNECT:"$SOCKET" 2>/dev/null || echo "idle")"
      if [[ "$STATUS" == *"recording"* ]]; then
        # Currently recording, so stop with plasma version
        ${dictate-wc-ptt-stop-plasma}/bin/dictate-wc-ptt-stop-plasma
      else
        # Not recording, so start with original script
        dictate-wc-ptt-start 2>/dev/null || {
          echo "Original dictate-wc-ptt-start not found. Enable services.dictation-whispercpp first." >&2
          exit 1
        }
      fi
    else
      # Daemon not running, start recording with original script
      dictate-wc-ptt-start 2>/dev/null || {
        echo "Original dictate-wc-ptt-start not found. Enable services.dictation-whispercpp first." >&2
        exit 1
      }
    fi
  '';

  # Auto-stop variants for plasma
  dictate-fw-ptt-auto-plasma = pkgs.writeShellScriptBin "dictate-fw-ptt-auto-plasma" ''
    TIMEOUT=''${1:-5}  # Default 5 seconds, or pass as argument
    
    # Start recording with original script
    dictate-fw-ptt-start 2>/dev/null || {
      echo "Original dictate-fw-ptt-start not found. Enable services.dictation-faster first." >&2
      exit 1
    }
    
    # Wait for timeout, then stop with plasma version
    sleep "$TIMEOUT"
    ${dictate-fw-ptt-stop-plasma}/bin/dictate-fw-ptt-stop-plasma
  '';

  dictate-wc-ptt-auto-plasma = pkgs.writeShellScriptBin "dictate-wc-ptt-auto-plasma" ''
    TIMEOUT=''${1:-5}  # Default 5 seconds, or pass as argument
    
    # Start recording with original script
    dictate-wc-ptt-start 2>/dev/null || {
      echo "Original dictate-wc-ptt-start not found. Enable services.dictation-whispercpp first." >&2
      exit 1
    }
    
    # Wait for timeout, then stop with plasma version
    sleep "$TIMEOUT"
    ${dictate-wc-ptt-stop-plasma}/bin/dictate-wc-ptt-stop-plasma
  '';

in
{
  options.services.dictation-plasma = {
    enable = lib.mkEnableOption "Plasma-compatible dictation wrappers using ydotool";
    
    enableFasterWhisper = lib.mkOption {
      type = lib.types.bool;
      default = config.services.dictation-faster.enable or false;
      description = "Enable Plasma wrappers for faster-whisper dictation";
    };
    
    enableWhisperCpp = lib.mkOption {
      type = lib.types.bool;
      default = config.services.dictation-whispercpp.enable or false;
      description = "Enable Plasma wrappers for whisper-cpp dictation";
    };
  };

  config = lib.mkIf config.services.dictation-plasma.enable {
    # Note: You must add your user to the 'uinput' group in your NixOS configuration:
    # users.users.<username>.extraGroups = [ "uinput" ];

    # ydotool daemon service
    systemd.user.services.ydotoold = {
      Unit = {
        Description = "ydotool daemon for Plasma dictation";
        Documentation = [ "man:ydotool(1)" "man:ydotoold(8)" ];
      };
      Service = {
        ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-path /tmp/ydotools";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    # Set ydotool socket environment variable
    home.sessionVariables = {
      YDOTOOL_SOCKET = "/tmp/ydotools";
    };

    # Install plasma-compatible scripts
    home.packages = with pkgs; [
      ydotool
    ] ++ lib.optionals config.services.dictation-plasma.enableFasterWhisper [
      dictate-fw-ptt-stop-plasma
      dictate-fw-ptt-toggle-plasma 
      dictate-fw-ptt-auto-plasma
    ] ++ lib.optionals config.services.dictation-plasma.enableWhisperCpp [
      dictate-wc-ptt-stop-plasma
      dictate-wc-ptt-toggle-plasma
      dictate-wc-ptt-auto-plasma
    ];

    # Warnings if base modules aren't enabled
    warnings = lib.optionals (config.services.dictation-plasma.enableFasterWhisper && !(config.services.dictation-faster.enable or false)) [
      "dictation-plasma.enableFasterWhisper is true but services.dictation-faster.enable is false"
    ] ++ lib.optionals (config.services.dictation-plasma.enableWhisperCpp && !(config.services.dictation-whispercpp.enable or false)) [
      "dictation-plasma.enableWhisperCpp is true but services.dictation-whispercpp.enable is false"  
    ];
  };
}
