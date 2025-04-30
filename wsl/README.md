There is no official WSL distro for NixOS, but the community have one here https://github.com/nix-community/NixOS-WSL
- put `wsl/configuration.nix` and `wsl/flake.nix` in `/etc/nixos/`
- run
  ```
  $ sudo nix flake update --flake /etc/nixos/ \
      --extra-experimental-features nix-command \
      --extra-experimental-features flakes
  ```
- run `sudo nixos-rebuild test --flake '/etc/nixos/' --impure` to test the expression
- run `sudo nixos-rebuild switch --flake '/etc/nixos/' --impure` to switch your system to the expression
- occasionally run `nix-collect-garbage -d` to clean up garbage (or enable this to happen automatically)
