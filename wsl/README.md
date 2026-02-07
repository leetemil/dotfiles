There is no official WSL distro for NixOS, but the community have one here https://github.com/nix-community/NixOS-WSL
- on your fresh WSL install, clone this repo with:
```sh
$ nix-shell -p git --run 'git clone https://github.com/leetemil/dotfiles.git'
```
- symlink `wsl/configuration.nix`, `wsl/certs.nix` and `wsl/flake.nix` in `/etc/nixos/`:
```sh
# do link with absolute path; modify as needed
sudo rm -rf /etc/nixos
sudo ln --symbolic --force /home/epe/repos/dotfiles/wsl/ /etc/nixos
```
- run this command to update flake inputs:
```sh
$ nix-shell -p git \
    --run 'sudo nix flake update \
             --flake /etc/nixos/ \
             --extra-experimental-features nix-command \
             --extra-experimental-features flakes'
```
- run `sudo nixos-rebuild test --flake '/etc/nixos/' --impure` to test the expression
- run `sudo nixos-rebuild switch --flake '/etc/nixos/' --impure` to switch your system to the expression
- symlink other things with `./wsl/setup.nu`; see script for details.
- occasionally run `nix-collect-garbage -d` to clean up garbage (or enable this to happen automatically)

Then, on your Windows host OS:
- if you want WSL to autostart `zellij`, you can change the WSL profile for NixOS to take the args `-- (cd ~); zellij`.
  Note that this is Nushell notation (as Nu is the default shell).
- some emojis do not render out of the box with font `Cascadia Code`;
  go get the latest release here https://github.com/microsoft/cascadia-code/releases and install a Nerd Font (NF) variant.
  Set font to `Cascadia Code NF` in WSL.

### Other things
- The `git` (Git for Windows) integration should have all the things you need, but you need to run this magic spell for it to work:
  ```
  git config --global credential.helper '/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe'
  ```
