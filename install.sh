#! /bin/bash

# install rust and cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# install starship
curl -fsSL https://starship.rs/install.sh | bash
