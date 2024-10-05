{pkgs, options, ...}:

{
  imports =
    [ # include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nix-alien.nix
      /home/emp/stuff/nix-playground/osquery-service.nix
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
    firewall = {
      enable = true;
      extraCommands = ''
        iptables -P INPUT DROP
      '';
    };

  };

  time.timeZone = "Europe/Copenhagen";

  virtualisation = {  
    docker = {
      enable = true;
    };
  };

  users.users = {
      emp = {
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
    };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # there is an issue with clamav version 1.3.1, so use overlay to fix that
    (final: prev: {
      clamav = prev.clamav.overrideAttrs (old: rec {
        version = "1.4.0";
        src = pkgs.fetchurl {
          url = "https://www.clamav.net/downloads/production/${old.pname}-${version}.tar.gz";
          hash = "sha256-1nqymeXKBdrT2imaXqc9YCCTcqW+zX8TuaM8KQM4pOY=";
        };
      });
    })
  ];
  
  environment.systemPackages = with pkgs; [
    age
    alacritty
    bash-language-server
    bazel_7    bazel-buildtools
    black
    brightnessctl
    btop
    buf-language-server
    capitaine-cursors
    carapace
    chromium
    clamav
    clickhouse
    cobra-cli
    cups
    curl
    delve
    devenv
    dig
    dockerfile-language-server-nodejs
    file
    firefox
    git
    glib
    glow
    gnumake
    go
    golangci-lint
    golangci-lint-langserver
    gopls
    go-task
    gotools
    grafana
    grim
    grimblast
    gtk3
    helix
    helm-ls
    home-manager
    htop
    hyprcursor
    hypridle
    hyprlock
    hyprshot
    isort
    jq
    just
    kubectl
    kubelogin-oidc
    kubernetes-helm
    kubeseal
    lazygit
    libgcc
    libgcrypt
    marp-cli
    minio-client
    nautilus
    nemo
    networkmanagerapplet
    networkmanager-openvpn
    nftables
    nil
    nix-index
    nix-prefetch-scripts
    nwg-look
    openssh
    openssl
    opentofu
    openvpn
    patchelf
    pavucontrol
    pipenv
    polkit-kde-agent
    postgresql
    protobuf
    protoc-gen-go
    protoc-gen-go-grpc
    pyenv
    pyright
    qemu
    ranger
    ripgrep
    ruby
    rubyPackages.solargraph
    ruff-lsp
    rust-analyzer
    rustup
    slurp
    socat
    starship
    swappy
    swaynotificationcenter
    traceroute
    tree
    udisks2
    unzip
    vim
    vscode
    vscode-langservers-extracted
    waybar
    wget
    which
    wl-clipboard
    wlsunset
    wofi
    xcur2png
    xz
    yaml-language-server
    yazi
    yq
    zellij
    zlib

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

  # install a stub ELF loader to print an informative error message in the event 
  # that a user attempts to run an ELF binary not compiled for NixOS
  environment.stub-ld.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
    WLR_NO_HARDWARE_CURSORS = "1"; # might fix invisible cursor
    SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
    GOPROXY = "https://goproxy.one.com,https://proxy.golang.org,direct";
  };

  programs = {
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

  services = {
    printing = {
      enable = true;
    };
    
    # to detect printers automagically
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

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
    extraOptions = ''
      trusted-users = root emp
    '';
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

