# UNUSED: leaving for the future.
# TODO: Figure out how to overlay my lib with main lib.
{ lib, ... }:

let
  inherit (builtins) map attrNames readDir;
  inherit (lib) filterAttrs hasSuffix;
in rec {
  # Map fn across nix files in directory. Does not recurse.
  mapModules = dir: fn:
    let
      dirAttrs = readDir dir;
      fileAttrs =
        filterAttrs (n: v: v == "regular" && (hasSuffix ".nix" n)) dirAttrs;
      pathFn = n: fn ("${toString dir}/${n}");
    in map pathFn (attrNames fileAttrs);
}
