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
