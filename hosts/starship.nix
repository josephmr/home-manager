{ ... }:

{
  imports = [ ../modules.spotify.nix ];

  home = {
    stateVersion = "22.11";

    username = "joseph";
    homeDirectory = "/home/joseph";
  };

  modules.spotify.enable = true;

  programs.git.userEmail = "rollins.joseph@gmail.com";
  modules.tailscale.systemd.enable = true;
}
