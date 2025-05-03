{inputs, pkgs, options, ...}:

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
      # first ACCEPT rule is for kitchen multicasting
      # second rule is to please osquery
      extraCommands = ''
        iptables -A INPUT -d 239.0.0.0/8 -j ACCEPT
        ip6tables -P INPUT DROP
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
        extraGroups = [ "wireshark" "docker" "kvm" "wheel" "input" "video" "audio" "disk" "networkmanager" "systemd-journal" ];
        packages = [];
      };
      emil = {
        createHome = true;
        isNormalUser = true;
        description = "";
        home = "/home/emil";
        uid = 1001;
        group = "users";
        shell = pkgs.nushell;
        extraGroups = [ "docker" "kvm" "wheel" "input" "video" "audio" "disk" "networkmanager" "systemd-journal" ];
        packages = [];
      };
    };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "dotnet-core-combined"
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-7.0.410"
      "dotnet-sdk-wrapped-6.0.428"
    ];
  };
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
    alacritty
    bash-language-server
    bazel_7
    gh
    bazel-buildtools
    brightnessctl
    buf
    marksman
    markdown-oxide
    ocaml
    dotnet-sdk_8
    roslyn-ls
    csharp-ls
    capitaine-cursors
    btop
    carapace
    chromium
    minikube
    clamav
    isort
    wireshark
    nftables
    clickhouse
    cobra-cli
    cups
    curl
    netcoredbg
    xournalpp
    delve
    devenv
    dig
    age
    opentofu
    dive
    wlsunset
    dockerfile-language-server-nodejs
    file
    firefox
    git
    glib
    glow
    go
    golangci-lint
    golangci-lint-langserver
    gopls
    go-task
    gotools
    grafana
    jujutsu
    rclone
    grim
    grimblast
    gtk3
    helix
    helm-ls
    home-manager
    pavucontrol
    htop
    hyprcursor
    hypridle
    black
    gnumake
    hyprlock
    hyprshot
    lazygit
    jq
    just
    kubectl
    kubernetes-helm
    kubelogin-oidc
    kubeseal
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
    openvpn
    patchelf
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
    socat
    slurp
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
    libgcc
    wl-clipboard
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
    DOTNET_CLI_TELEMETRY_OPTOUT = 1; # disable dotnet telemetry
  };

  programs = {
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      xwayland.enable = false;
    };
    git.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
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
    noto-fonts
    powerline-fonts
    fira-sans
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

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

