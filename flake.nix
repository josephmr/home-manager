{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      darwinPkgs = nixpkgs.legacyPackages.aarch64-darwin;
      linuxPkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      homeConfigurations = {
        "jrollins@Josephs-MBP" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;
          modules = [ ./common.nix ./hosts/mbp.nix ];
        };

        "fortruce@weasl" = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;
          modules = [ ./common.nix ./hosts/weasl.nix ];
        };
      };
    };
}
