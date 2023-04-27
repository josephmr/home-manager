{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.spotify;
in {
  options.modules.spotify = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    { home.packages = with pkgs; [ spotify ]; }
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      xdg.desktopEntries.spotify = {
        name = "Spotify";
        exec = "${getExe pkgs.spotify}";
        terminal = false;
        categories = [ "Audio" "Music" ];
        mimeType = [ "x-scheme-handler/spotify" ];
      };
    })
  ]);
}
