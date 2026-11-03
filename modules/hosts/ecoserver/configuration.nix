{ self, inputs, ... }: {
  
  flake.nixosModules.ecoserverConfiguration = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = with self.nixosModules; [
      ssh # Depends on ecoserverSSH
      continuwuity
      podman

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
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${selfpkgs.myEnvironment}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    # ================== #
    # === NETWORKING === #
    # ================== #
    
    services.caddy.enable = true;

    services.caddy.virtualHosts."budibase.econadzor.org".extraConfig = ''
      reverse_proxy 127.0.0.1:10000
    '';

    services.caddy.virtualHosts."wiki.econadzor.org".extraConfig = ''
      reverse_proxy 127.0.0.1:3200
    '';

    services.caddy.virtualHosts."stream.econadzor.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8085
    '';

    services.caddy.virtualHosts."git.sljusard.com".extraConfig = ''
      reverse_proxy 127.0.0.1:3000
    '';

    services.caddy.virtualHosts."mail.econadzor.org".extraConfig = ''
      reverse_proxy https://127.0.0.1:8443 {
        transport http {
          tls_insecure_skip_verify
        }
        header_up Host {host}
        header_up X-Forwarded-Proto https
        header_up X-Forwarded-For {remote_host}
      }
    '';

    services.caddy.virtualHosts."inbox.econadzor.org".extraConfig = ''
      reverse_proxy 127.0.0.1:8340
    '';

    services.caddy.virtualHosts."vw.econadzor.org".extraConfig = ''
      reverse_proxy 127.0.0.1:3800
    '';

    services.caddy.virtualHosts."sljussar.de".extraConfig = ''
      reverse_proxy 127.0.0.1:3100
    '';

    services.caddy.virtualHosts."chat.econadzor.org".extraConfig = ''
      reverse_proxy 127.0.0.1:6100
    '';

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

    networking.hosts = {
      "127.0.0.1" = [ 
        "econadzor.org" 
        "matrix.econadzor.org"
        "livekit.econadzor.org"
        "grafana.sljusard.com"
        "test.econadzor.org"
      ];
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
