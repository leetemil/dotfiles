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
- if you want WSL to autostart `zellij`, you can change the WSL profile for NixOS to take the args `-- (cd ~); zellij`.
  Note that this is Nushell notation (as Nu is the default shell).
- some emojis do not render out of the box with font `Cascadia Code`;
  go get the latest release here https://github.com/microsoft/cascadia-code/releases and install a Nerd Font (NF) variant.
  Set font to `Cascadia Code NF` in WSL.
- run `$ sudo -sH nu ./wsl/setup.nu` to symlink stuff from the repo; see script for details.
