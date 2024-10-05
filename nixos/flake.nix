{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    osquery.url = "path:/home/emp/repos/cthulhu/ogcode/tools/osquery/";
  };

  outputs = {nixpkgs, osquery, ...}: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.emp-laptop = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        # osquery.nixosModules.default
      ];
    };
  };
}
