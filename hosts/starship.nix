{ ... }:

{
  home = {
    stateVersion = "22.11";

    username = "joseph";
    homeDirectory = "/home/joseph";
  };

  programs.git.userEmail = "rollins.joseph@gmail.com";
  modules.tailscale.systemd.enable = true;
}
