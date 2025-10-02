# Edit this configuration file to define what should be installed on your system. Help is available in the 
# configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository: 
# https://github.com/nix-community/NixOS-WSL

{ pkgs, ... }:

{ imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ./certs.nix
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  wsl.enable = true; wsl.defaultUser = "epe";

  users.users = {
      epe = {
        createHome = true;
        isNormalUser = true;
        description = "Emil Petersen";
        home = "/home/epe";
        uid = 1000;
        group = "users";
        shell = pkgs.nushell;
        extraGroups = [ "docker" "kvm" "wheel" "input" "video" "audio" "disk" "networkmanager" "systemd-journal" ];
        packages = [];
      };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    extraOptions = ''
      trusted-users = root epe
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [];
  };

  programs.nix-ld = {
    enable = true;
    libraries = [
      # add missing dynamic libs here, not in env sys packages
    ];
  };

  environment.systemPackages = with pkgs; [
    # internet tools
    curl
    dig
    nftables
    openssh
    openssl
    openvpn
    traceroute
    wget

    # vcs
    git
    jujutsu

    # editor, multiplexer, prompt
    helix
    starship
    zellij

    # nushell completion
    carapace

    # terminal tools
    btop
    jq
    ripgrep
    which
    yazi
    yq
    unzip
    tree
    docker

    azure-artifacts-credprovider
    marp-cli

    # nix nice-to-have
    patchelf

    # lsp/language stuff
    bash-language-server
    black
    csharp-ls
    dotnet-sdk
    nil
    nixd
    powershell
    powershell-editor-services
    terraform
    terraform-ls
    terraform-lsp
    yaml-language-server
    pyright
    starlark-rust
    unison-ucm

    # build systems
    buck2

    # other
    typst
    gcc
    ollama
    lsp-ai
    glow

    nodejs_22

    # go
    go
    golangci-lint-langserver
    golangci-lint
    gopls

    # rust
    rustup
    trunk
    leptosfmt
    cargo-leptos
    # rust-analyzer

    # az cli
    (azure-cli.withExtensions [
       azure-cli.extensions.azure-devops
    ])

    # python3
    (python3.withPackages(ps: with ps; [ 
      # treelib 
      pyyaml
      setuptools
      natsort
      pydantic
      pydantic-extra-types
      requests
      boto3
      botocore
      ruff
      "azure.mgmt"
      python-lsp-server
      python-lsp-ruff
    ]))
  ];

  # fonts
  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    jetbrains-mono
    font-awesome
    noto-fonts
    powerline-fonts
    fira-sans
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # This value determines the NixOS release from which the default settings for stateful data, like file 
  # locations and database versions on your system were taken. It's perfectly fine and recommended to leave this 
  # value at the release version of the first install of this system. Before changing this value read the 
  # documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
