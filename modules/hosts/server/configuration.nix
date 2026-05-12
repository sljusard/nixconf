{ self, inputs, ... }: {
  
  flake.nixosModules.ecoserverConfiguration = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports =
    [
      ssh
      neovim
      continuwuity
      ecoserverHardware
    ];

    boot.loader.systemd-boot.enable = true;
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

    networking.hostName = "ecoserver";

    networking.hosts = {
      "127.0.0.1" = [ 
        "econadzor.org" 
        "matrix.econadzor.org"
        "livekit.econadzor.org"
      ];
    };
  
    networking.networkmanager.enable = true;

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
    services.pipewire = {
      enable = true;
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
      firefox
    ];
    programs.yazi.enable = true;

    programs.git.enable = true;
    programs.git.package = selfpkgs.myGit;

    programs.fish.enable = true;
    programs.fish.package = selfpkgs.myEnvironment;

    services.caddy.enable = true;

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 80 443 10000 ];

    system.stateVersion = "25.11";
  };
}
