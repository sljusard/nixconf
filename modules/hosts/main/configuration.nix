{ self, inputs, ... }: {

  flake.nixosModules.noosphereConfiguration = { pkgs, lib, config, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {

    # ======================== #
    # === NixOS ESSENTIALS === #
    # ======================== #

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    networking.hostName = "noosphere";
    networking.networkmanager.enable = true;
    networking.wireless.enable = true;

    hardware.bluetooth.enable = true;

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
    # === HARDWARE === #
    # ================ #

    powerManagement.cpuFreqGovernor = "performance";

    hardware.graphics.enable = true;

    # Nvidia GPU settings
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
    hardware.nvidia-container-toolkit.enable = true;

    # ===================== #
    # === LOGIN MANAGER === #
    # ===================== #

    services.displayManager.defaultSession = "niri";
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      extraPackages = with pkgs; [
        kdePackages.qtmultimedia
      ];
      theme = "sddm-astronaut-theme";
    };

    # ================ #
    # === KEYBOARD === #
    # ================ #

    services.xserver.xkb = {
      layout = "us,us,ru";
      variant = ",colemak,";
      options = "grp:alt_shift_toggle,compose:rctrl";
    };

    # ===================== #
    # === USER SETTINGS === #
    # ===================== #

    users.users.cypher = {
      isNormalUser = true;
      description = "Cypher";
      extraGroups = [ "input" "networkmanager" "wheel" "gamemode" "podman" "scanner" "lp" "libvirtd" ];
      packages = with pkgs; [
        vlc
        obs-studio
        telegram-desktop
        gimp
        obsidian
        vesktop
        libreoffice-qt
        cliamp
        anki-bin
        digikam
        element-desktop
      ];
    };

    # ========================== #
    # === MODULES & PACKAGES === #
    # ========================== #
    
    nixpkgs.config.allowUnfree = true;

    imports = with self.nixosModules; [
      gaming
      audio
      podman
      desktop
      ssh # Depends on noosphereSSH
      passwords
      ai
      virtualisation

      # Host-specific modules
      noosphereSSH
      org-backup
      noosphereHardware # Always keep this one!
    ];

    environment.systemPackages = with pkgs; [
      emacs
      qbittorrent
      exfat
      warehouse
      darktable
      udiskie
      filezilla
      naps2
      tree-sitter
      gcc
      sqlite
      pandoc
      wl-clipboard
      sddm-astronaut
      tetex
      dmidecode
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.dvr-patched.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    fonts.packages = [
      pkgs.monocraft
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    # ========================= #
    # === FILESYSTEM MOUNTS === #
    # ========================= #

    # Second SSD
    fileSystems."/mnt/storage" = { 
      device = "/dev/disk/by-uuid/ececae3e-ecff-48a1-92c7-e0c0b7f45e78";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    # NAS mount
    boot.supportedFilesystems = [ "nfs" ];
    services.rpcbind.enable = true;

    fileSystems."/mnt/warehouse" = {
      device = "192.168.1.10:/nfs/warehouse";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60" ];
    };

    # ====================== #
    # === SHELL SETTINGS === #
    # ====================== #

    # programs.zsh.enable = true;
    # users.defaultUserShell = pkgs.zsh;

    programs.fish.shellAliases = {
      winboot = "sudo bootctl set-oneshot auto-windows && reboot";
      rebuild = "sudo nixos-rebuild switch --flake .#noosphere";
      niri-displayfix = "niri msg output HDMI-A-1 mode 2560x1440@143.996";
      doom = "~/.config/emacs/bin/doom emacs 2>/dev/null & disown";
      dvr = "distrobox enter resolve -- resolve-launch";
    };

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 11345 ];

    # ===================== #
    # === TIME & LOCALE === #
    # ===================== #

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

    # ====================== #
    # === OTHER SETTINGS === #
    # ====================== #

    services.udisks2.enable = true;

    services.printing.enable = true;
    hardware.sane.enable = true;
    hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;

    # Allow Git to push from mounted NAS
    environment.etc."gitconfig".text = ''
      [safe]
        directory = /mnt/nas/games/installers
    '';

    programs.labwc.enable = true;

    programs.yazi.enable = true;
    programs.lazygit.enable = true;

    services.flatpak.enable = true;
    services.lact.enable = true;

    programs.thunderbird.enable = true;
    services.protonmail-bridge.enable = true;

    system.stateVersion = "25.11"; # Do not touch!
  };
}
