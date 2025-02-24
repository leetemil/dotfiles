let
  pkgs = import <nixpkgs>{};

  # check out releases here
  # https://homebrew.g1i.one/systems-tap/one.com-osquery/
  # and copy the url of the package you want
  url = "https://homebrew.g1i.one/systems-tap/one.com-osquery/dcd6a3e2469943bd3759cf7b3fbe08bef01478d1915843533817386a773d15c1.tar.gz";

  onecom_osquery = pkgs.stdenv.mkDerivation {
    name = "one.com-osquery";
    src = pkgs.fetchurl {
      url = url;
      # you can get the hash with `$ nix-prefetch-url <URL>`,
      # but usually nix will tell you the hash it got and you can just copy
      sha256 = "1h8m7mvnlf0p719l6n4is5w19w5y12z3yyygb4vvshwr8via7mnw";
    };
    unpackPhase = ''
      tar -xf $src
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp -r * $out/
      ln -s $out/nftools.linux-x86_64 $out/bin/nftools
      ln -s $out/osqueryi.linux-x86_64 $out/bin/osqueryi
      ln -s $out/osquery_exporter.linux-x86_64 $out/bin/osquery_exporter
    '';

    # binaries are not working out of the box, so we patch
    # see https://nixos.wiki/wiki/FAQ for details
    postFixup = ''
      patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          $out/bin/nftools \
          $out/bin/osquery_exporter \
          $out/bin/osqueryi
    '';
  };
in
{
  # this part is not DRY; if the service file changes, change here as well
  systemd.services."one.com-osquery" = {
    enable = true;
    restartIfChanged = true;
    wantedBy = [ "default.target" ];

    description = "Service for osquery exporter";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ "${onecom_osquery}" ];

    serviceConfig = {
      Type = "simple";
      User = "root";
      Group = "root";
      ExecStart=''
        ${onecom_osquery}/bin/osquery_exporter \
          -config-file ${onecom_osquery}/config_linux.yaml \
          -push-address https://push.one.com \
          -push-frequency 3600s \
          -cache-ttl 21600s
      '';
    };
  };
}
