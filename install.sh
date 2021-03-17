#! /bin/bash

# install rust and cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# install packages
apt-get install -y zsh git neovim bat exa

# # install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install antibody
curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

# install starship
curl -fsSL https://starship.rs/install.sh | bash
