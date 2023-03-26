{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.emacs;
in {
  options.modules.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      binutils
      # 28.2 + native-comp
      ((emacsPackagesFor emacsNativeComp).emacsWithPackages
        (epkgs: [ epkgs.vterm ]))

      ## Doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
    ];

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    # TODO: Maybe this can be simplified. See https://discourse.nixos.org/t/home-manager-home-activation-access-to-packages-in-home-packages/26732
    home.activation.install-doom = hm.dag.entryAfter [ "writeBoundary" ] ''
      if ! [ -d "${config.xdg.configHome}/emacs" ]; then
        PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH" \
          $DRY_RUN_CMD git clone $VERBOSE_ARG --depth=1 --single-branch \
          "https://github.com/doomemacs/doomemacs.git" \
          "${config.xdg.configHome}/emacs"
      fi
      if ! [ -d "$HOME/.doom.d" ]; then
         PATH="${pkgs.git}/bin:${pkgs.openssh}/bin:$PATH" \
          $DRY_RUN_CMD git clone $VERBOSE_ARG --depth=1 --single-branch \
          "https://github.com/josephmr/.doom.d.git" \
          "$HOME/.doom.d"
      fi
    '';
  };
}
