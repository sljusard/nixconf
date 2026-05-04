{ self, inputs, ... }: {

  flake.nixosModules.noosphereConfiguration = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = with self.nixosModules; [
        noosphereHardware
        gaming
	audio
	neovim
	desktop
        ssh
	passwords
	ai
      ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    networking.hostName = "noosphere";

    # Automatic upgrading
    system.autoUpgrade.enable = true;
    system.autoUpgrade.dates = "weekly";

    # Automatic cleanup
    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = "--delete-older-than 7d";
    nix.settings.auto-optimise-store = true;

    # GPU settings
    hardware.graphics.enable = true;

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = pkgs.linuxPackages_latest.nvidiaPackages.beta;
    };

    hardware.nvidia.prime = {
      sync.enable = true;

      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };

    services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

    services.displayManager = {
      plasma-login-manager.enable = true;
      defaultSession = "niri";
    };

    networking.networkmanager.enable = true;
    networking.wireless.enable = true;

    hardware.bluetooth.enable = true;
    services.udisks2.enable = true;
    services.printing.enable = true;

    services.xserver.xkb = {
      layout = "us,us,ru";
      variant = ",colemak,";
      options = "
        grp:alt_shift_toggle,
	compose:rctrl
      ";
    };

    time.timeZone = "Europe/Moscow";

    i18n.defaultLocale = "ru_RU.UTF-8";
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

    nixpkgs.config.allowUnfree = true;

    users.users.cypher = {
      isNormalUser = true;
      description = "Cypher";
      extraGroups = [ "networkmanager" "wheel" "gamemode" ];
      packages = with pkgs; [
        qbittorrent
        vlc
        obs-studio
        telegram-desktop
        gimp
	obsidian
        discord
        davinci-resolve
	element-desktop
        vesktop
        libreoffice-qt
      ];
    };

  environment.systemPackages = with pkgs; [
      emacs
      exfat
#      bottles
      warehouse
      gparted
      darktable
      udiskie
#      slurp
#      grim
      lynx
#      satty
      filezilla
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = [
    pkgs.monocraft
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  programs.yazi.enable = true;

  services.flatpak.enable = true;
  services.lact.enable = true;

  programs.ssh = {
    extraConfig = "
      Host ecoserver
	Hostname 217.114.188.94
	Port 4572
	User sljusard
   ";
   startAgent = true;
  };

  services.gnome.gcr-ssh-agent.enable = false;

  programs.bash.shellAliases = {
    winboot = "sudo bootctl set-oneshot auto-windows && reboot";
    rebuild = "sudo nixos-rebuild switch";
    niri-displayfix = "niri msg output HDMI-A-1 mode 2560x1440@143.996";
  };

  networking.firewall.enable = true;

  system.stateVersion = "25.11"; 
  };
}
