{
  description = "First draft of a flake'd NixOS setup";

  inputs = {
    # unstable channel
    pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };


  outputs = { self, nixpkgs, ...}@inputs: {

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.emp-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ] ;
    };
  };
}
