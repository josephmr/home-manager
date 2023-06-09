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
    home.packages = with pkgs;
      [
        # 28.2 + native-comp
        ((emacsPackagesFor emacsNativeComp).emacsWithPackages
          (epkgs: [ epkgs.vterm ]))
        emacs-all-the-icons-fonts

        ## Doom dependencies
        git
        (ripgrep.override { withPCRE2 = true; })
        gnutls # for TLS connectivity

        ## Optional dependencies
        fd # faster projectile indexing
        imagemagick # for image-dired

        nixfmt
      ] ++ optionals stdenv.hostPlatform.isDarwin [
        # for org-download
        pngpaste
      ] ++ optionals stdenv.hostPlatform.isLinux [ xclip ];

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    # Wait for "onFilesChange" so "gh:" url rewrite will be present in git
    # config
    home.activation.install-doom =
      hm.dag.entryAfter [ "writeBoundary" "onFilesChange" ] ''
        if ! [ -d "${config.xdg.configHome}/emacs" ]; then
            $DRY_RUN_CMD ${
              getExe pkgs.git
            } clone $VERBOSE_ARG --depth=1 --single-branch \
            "gh:doomemacs/doomemacs.git" \
            "${config.xdg.configHome}/emacs"
        fi
        if ! [ -d "$HOME/.doom.d" ]; then
            $DRY_RUN_CMD ${
              getExe pkgs.git
            } clone $VERBOSE_ARG --depth=1 --single-branch \
            "gh:josephmr/.doom.d.git" \
            "$HOME/.doom.d"
        fi
      '';
  };
}
