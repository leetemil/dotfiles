# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nix-alien.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };

  networking = {
    hostName = "emp-laptop";
    networkmanager.enable = true;
    # add DK time servers
    timeServers = options.networking.timeServers.default ++ [ 
      "0.dk.pool.ntp.org" 
      "1.dk.pool.ntp.org" 
      "2.dk.pool.ntp.org" 
      "3.dk.pool.ntp.org" 
    ];
    firewall.enable = true;
  };

  time.timeZone = "Europe/Copenhagen";
  sound.enable = true;

  virtualisation = {  
    docker = {
      enable = true;
    };
  };

  users.users.emp = {
    createHome = true;
    isNormalUser = true;
    description = "Emil Petersen";
    home = "/home/emp";
    uid = 1000;
    group = "users";
    shell = pkgs.nushell;
    extraGroups = [ "docker" "kvm" "wheel" "input" "video" "audio" "disk" "networkmanager" "systemd-journal" ];
    packages = [];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    networkmanagerapplet
    openvpn
    networkmanager-openvpn
    which
    helix
    chromium
    alacritty
    starship
    wl-clipboard
    grimblast
    home-manager
    gnome.nautilus
    cinnamon.nemo
    nix-prefetch-scripts
    nix-index
    udisks2
    firefox
    brightnessctl
    waybar
    swaynotificationcenter
    polkit-kde-agent
    xdg-desktop-portal-hyprland
    slurp
    wofi
    hyprlock
    hypridle
    hyprshot
    jq
    yq
    grim
    swappy
    clamav
    kubectl
    libgcrypt
    ranger
    file
    patchelf
    ruby
    qemu
    openssh
    dig
    curl
    zlib
    ripgrep
    go
    vscode
    yazi
    glow

    # bazelisk
    bazel
    bazel-buildtools
    protoc-gen-go
    protoc-gen-go-grpc
    protobuf
    delve
    gotools

    # language servers
    vscode-langservers-extracted
    gopls
    golangci-lint
    golangci-lint-langserver
    yaml-language-server
    bash-language-server
    dockerfile-language-server-nodejs
    helm-ls
    nil
    buf-language-server
    pyright
    ruff-lsp
    rust-analyzer

    carapace
    clickhouse
    xz
    openssl
    minio-client
    kubernetes-helm
    grafana
    unzip
    traceroute
    kubeseal

    # python3
    (python3.withPackages(ps: with ps; [ 
      # group-authdns
      treelib 
      pyyaml
      setuptools
      natsort
      # damip
      pynetbox
      pydantic
      pydantic-extra-types
      requests
      boto3
      botocore
      ruff
    ]))
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
  };

  programs = {
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    hyprland = {
      enable = true;
      xwayland.enable = false;
    };
    git.enable = true;
    ssh.startAgent = true;

    nix-ld = {
      enable = true;

      # all the libraries to load - right now just random libs that i found here
      # https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        openssl
        expat
        glib
        gtk3
        icu
        libGL
        libappindicator-gtk3
        libdrm
        libglvnd
        libnotify
        libpulseaudio
        libunwind
        libusb1
        libuuid
        libxkbcommon
        libxml2
        libgcc
        libgcrypt
        libxcrypt-legacy
      ];
    };
  };

  # services.openssh.enable = true;
  services = {
    # # one.com-flavored osquery service requires for compliance reasons - does not work yet: make some Nix-voodoo to build from cthulhu repo
    # osquery = {
    #   enabled = true;
    #   description = "Service for osquery exporter";
    #   serviceConfig = {
    #     ExecStart = "/usr/bin/osquery_exporter -config-file /etc/one.com/osquery/config.yaml -push-address https://push.one.com -push-frequency 3600s -cache-ttl 21600s";
    #     Group = "root";
    #     User = "root";
    #     Type = "simple";
    #   };
    #   wantedBy = [ "default.target" ];
    # };
    
    # this is the login prompt - it'll also run Hyprland once logged in
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "emp";
        };
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    udisks2.enable = true;
    # enable the ClamAV service and keep the database up to date
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
    envfs.enable = true;
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    jetbrains-mono
    font-awesome
    nerdfonts
    noto-fonts
    powerline-fonts
    fira-sans
  ];
 
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 7d";
    # };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
  system.autoUpgrade.enable = true;

}

