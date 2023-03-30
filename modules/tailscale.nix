{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.tailscale;
in {
  options.modules.tailscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    systemd.enable = mkEnableOption "Tailscale systemd integration";
  };

  config = mkIf cfg.enable (mkMerge [
    { home.packages = with pkgs; [ tailscale ]; }

    (mkIf cfg.systemd.enable {
      home.activation.install-tailscaled = ''
        if ! [ -e "/etc/systemd/system/tailscaled.service"  ]; then
          printf "$(tput setaf 1)!! SYSTEMD SERVICE NOT INSTALLED, RUN:\n!! sed 's/[$]{PORT} [$]FLAGS/41641/' ${pkgs.tailscale}/lib/systemd/system/tailscaled.service | sudo tee /etc/systemd/system/tailscaled.service\n!! systemctl start tailscaled.service\n$(tput sgr0)"
        fi
      '';

    })
  ]);
}
