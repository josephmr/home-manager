{ config, lib, ... }:

with lib;
let cfg = config.programs.git;
in {
  config = mkIf cfg.enable {
    programs.git = {
      userName = "Joseph Rollins";
      extraConfig = {
        url = {
          "ssh://git@github.com/" = { insteadOf = "https://github.com/"; };
        };
        github.user = "josephmr";
        core.excludesfile = "${config.home.homeDirectory}/.gitignore";
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = true;
          light = false;
        };
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };
  };
}
