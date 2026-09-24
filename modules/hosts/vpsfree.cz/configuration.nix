{ self, inputs, ... }: {
  
  flake.nixosModules.pragueAlphaConfiguration = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = with self.nixosModules; [
      ssh # Depends on pragueAlphaSSH
      podman

      # Host specific modules
      inputs.vpsadminos.nixosModules.containerUnstable
      pragueAlphaSSH
      pragueAlphaHardware
    ];

    boot.loader.systemd-boot.enable = false;
    boot.isContainer = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
    # Automatic upgrading
    system.autoUpgrade.enable = false;
    system.autoUpgrade.dates = "weekly";

    # Automatic cleanup
    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = "--delete-older-than 7d";
    nix.settings.auto-optimise-store = true;

    networking.hostName = "prague-alpha";

    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Netherlands";
    services.ntp.enable = true;

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

    services.xserver.enable = true;

    services.xserver.xkb = {
      layout = "us,us,ru";
      variant = ",colemak,";
      options = "
        grp:alt_shift_toggle,
      	compose:rctrl
      ";
    };

    services.printing.enable = false;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    virtualisation.docker.enable = true;

    services.pipewire = {
      enable = false;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.sljusard = {
      isNormalUser = true;
      description = "Denis Sliusar";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
      ];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      openssl
      jq
      gawk
    ];

    programs.yazi.enable = true;

    programs.git.enable = true;
    programs.git.package = selfpkgs.myGit;

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

    services.caddy.virtualHosts."cdn01.sljusard.com".extraConfig = ''
      # Panel
      # handle /bkLk5yLje293gufOSj/* {
      #   reverse_proxy 127.0.0.1:2100
      # }

      # Subscription
      handle /api/* {
        reverse_proxy 127.0.0.1:2096
      }
    '';

    services.caddy.virtualHosts."aigw.sljusard.com".extraConfig = ''
      reverse_proxy 127.0.0.1:4441
    '';

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 80 443 8080 ];
    networking.firewall.allowedUDPPorts = [ 59775 ];
    
    networking.hosts = {
      "127.0.0.1" = [ 
      ];
    };

    system.stateVersion = "26.11";
  };
}
