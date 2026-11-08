{ self, inputs, ... }: {
  
  flake.nixosModules.ecoserverConfiguration = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = with self.nixosModules; [
      ssh # Depends on ecoserverSSH
      continuwuity
      podman
      livekit

      # Host specific modules
      ecoserverHardware
      ecoserverSSH
    ];

    # ======================== #
    # === NixOS ESSENTIALS === #
    # ======================== #

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
    networking.hostName = "ecoserver";

    networking.networkmanager.enable = true;

    # =================== # 
    # === AUTOMATIONS === #
    # =================== #

    # Automatic upgrading
    system.autoUpgrade.enable = false;
    system.autoUpgrade.dates = "weekly";

    # Automatic cleanup
    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = "--delete-older-than 7d";
    nix.settings.auto-optimise-store = true;

    # ================ #
    # === KEYBOARD === #
    # ================ #

    services.xserver.xkb = {
      layout = "us,us,ru";
      variant = ",colemak,";
      options = "
        grp:alt_shift_toggle,
      	compose:rctrl
      ";
    };

    # ===================== #
    # === USER SETTINGS === #
    # ===================== #

    users.users.sljusard = {
      isNormalUser = true;
      description = "Denis Sliusar";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
      ];
    };

    # ========================== #
    # === MODULES & PACKAGES === #
    # ========================== #

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      openssl
      jq
      gawk
    ];

    # ====================== #
    # === SHELL SETTINGS === #
    # ====================== #

    programs.fish.enable = true;
    programs.fish.package = selfpkgs.myEnvironment;

    # ================== #
    # === NETWORKING === #
    # ================== #
    
    services.caddy.enable = true;
    services.caddy.virtualHosts = { 
      "budibase.econadzor.org".extraConfig = ''
        reverse_proxy 127.0.0.1:10000
      '';

      "wiki.econadzor.org".extraConfig = ''
        reverse_proxy 127.0.0.1:3200
      '';

      "stream.econadzor.com".extraConfig = ''
        reverse_proxy 127.0.0.1:8085
      '';

      "git.sljusard.com".extraConfig = ''
        reverse_proxy 127.0.0.1:3000
      '';

      "mail.econadzor.org".extraConfig = ''
        reverse_proxy https://127.0.0.1:8443 {
          transport http {
            tls_insecure_skip_verify
          }
          header_up Host {host}
          header_up X-Forwarded-Proto https
          header_up X-Forwarded-For {remote_host}
        }
      '';

      "inbox.econadzor.org".extraConfig = ''
        reverse_proxy 127.0.0.1:8340
      '';

      "vw.econadzor.org".extraConfig = ''
        reverse_proxy 127.0.0.1:3800
      '';

      "sljussar.de".extraConfig = ''
        reverse_proxy 127.0.0.1:3100
      '';

      "chat.econadzor.org".extraConfig = ''
        reverse_proxy 127.0.0.1:6100
      '';

      "rw.sljusard.org".extraConfig = ''
        reverse_proxy 127.0.0.1:3500
      '';

      "music.sljusard.org".extraConfig = ''
        reverse_proxy 192.168.88.64:4544
      '';

      "auth.econadzor.org".extraConfig = ''
        reverse_proxy 127.0.0.1:9091
      '';
    };

    networking.hosts = {
      "127.0.0.1" = [ 
        "econadzor.org" 
        "matrix.econadzor.org"
        "livekit.econadzor.org"
        "chat.econadzor.org"
        "grafana.sljusard.com"
        "mail.econadzor.org"
        "git.sljusard.com" # Forgejo
      ];
    };
  
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 
      80 443 # Caddy
      25 465 587 # SMTP
      143 993 # IMAP
      110 995 # POP3 
      4190 # Sieve 
      3022 4440 3389 # Other
      1935 # Owncast
    ];
    networking.firewall.allowedUDPPorts = [ 3389 8189 ];
    
    services.authelia.instances = { 
      econadzor-org = {
        enable = true;
        user = "sljusard";
        secrets = {
          jwtSecretFile = "/home/sljusard/authelia-secrets/jwt";
          sessionSecretFile = "/home/sljusard/authelia-secrets/session";
          storageEncryptionKeyFile = "/home/sljusard/authelia-secrets/storage";
        };
        settings = {
          theme = "auto";
          server.address = "tcp://127.0.0.1:9091/";
          authentication_backend = {
            file.path = "/var/lib/authelia-econadzor-org/users.yml";
            password_reset.disable = true;
          };
          access_control = {
            default_policy = "deny";
            rules = [{ domain = "wfr.econadzor.org"; policy = "one_factor"; }];
          };
          session.cookies = [{
            domain = "econadzor.org";
            authelia_url = "https://auth.econadzor.org";
          }];
          storage.local.path = "/var/lib/authelia-econadzor-org/db.sqlite3";
          notifier.filesystem.filename = "/var/lib/authelia-econadzor-org/notification.txt";
        };
      };
    };

    # ====================== #
    # === [TEST] GRAFANA === #
    # ====================== #
    
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3030;
          enforce_domain = false;
          enable_gzip = true;
          domain = "grafana.sljusard.com";
        };
        analytics.reporting_enabled = false;
        security.secret_key = "SW2YcwTIb9zpOOhoPsMm"; # Temp key, test purposes only
      };
    };
    
    services.prometheus.exporters.node = {
      enable = true;
      port = 9000;

      enabledCollectors = [
        "ethtool"
        "softirqs"
        "systemd"
        "tcpstat"
        "wifi"
      ];
    };

    # ===================== #
    # === TIME & LOCALE === #
    # ===================== #

    time.timeZone = "Asia/Yekaterinburg";

    i18n.defaultLocale = "en_IE.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };

    # ====================== #
    # === OTHER SETTINGS === #
    # ====================== #

    services.printing.enable = false;

    security.rtkit.enable = true;

    programs.yazi.enable = true;

    programs.git.enable = true;
    programs.git.package = selfpkgs.myGit;

    virtualisation.docker.enable = true;

    system.stateVersion = "25.11";
  };
}
