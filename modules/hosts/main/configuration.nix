{ self, inputs, ... }: {

  flake.nixosModules.noosphereConfiguration = { pkgs, lib, config, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = with self.nixosModules; [
      gaming
      audio
      podman
      desktop
      ssh # Depends on noosphereSSH
      passwords
      ai

      # Host-specific modules
      noosphereHardware
      noosphereSSH
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.supportedFilesystems = [ "nfs" ];

    fileSystems."/mnt/storage" = { 
      device = "/dev/disk/by-uuid/ececae3e-ecff-48a1-92c7-e0c0b7f45e78";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    boot.kernelPackages = pkgs.linuxPackages;

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
      package = config.boot.kernelPackages.nvidiaPackages.beta;
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
    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;

    services.xserver.xkb = {
      layout = "us,us,ru";
      variant = ",colemak,";
      options = "
        grp:alt_shift_toggle,
	      compose:rctrl
      ";
    };

    time.timeZone = "Europe/Moscow";

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

    nixpkgs.config.allowUnfree = true;

    users.users.cypher = {
      isNormalUser = true;
      description = "Cypher";
      extraGroups = [ "input" "networkmanager" "wheel" "gamemode" "podman" "scanner" "lp" ];
      packages = with pkgs; [
        qbittorrent
        vlc
        obs-studio
        telegram-desktop
        gimp
        obsidian
        # discord
        davinci-resolve
        vesktop
        libreoffice-qt
        protonmail-bridge
        cliamp
        anki
      ];
    };

  environment.systemPackages = with pkgs; [
      emacs
      exfat
      element-desktop
      warehouse
      darktable
      udiskie
      lynx
      filezilla
      naps2
      tree-sitter
      gcc
      sqlite
      pandoc
      wl-clipboard
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = [
    pkgs.monocraft
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  programs.yazi.enable = true;
  programs.lazygit.enable = true;

  services.flatpak.enable = true;
  services.lact.enable = true;

  programs.thunderbird.enable = true;

  programs.fish.shellAliases = {
    winboot = "sudo bootctl set-oneshot auto-windows && reboot";
    rebuild = "sudo nixos-rebuild switch --flake .#noosphere";
    niri-displayfix = "niri msg output HDMI-A-1 mode 2560x1440@143.996";
    doom = "~/.config/emacs/bin/doom emacs 2>/dev/null & disown";
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 11345 ];

  system.stateVersion = "25.11"; 
  };
}
