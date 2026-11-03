{ self, inputs, ... }: {

  flake.nixosModules.archmagosConfiguration = { pkgs, lib, config, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {

    # ======================== #
    # === NixOS ESSENTIALS === #
    # ======================== #

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    networking.hostName = "archmagos";
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

    # powerManagement.cpuFreqGovernor = "performance";

    hardware.graphics.enable = true;

    # Nvidia GPU settings
    hardware.nvidia = {
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

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
      extraGroups = [ "input" "networkmanager" "wheel" "gamemode" "podman" "scanner" "lp" "libvirtd" "media" ];
      packages = with pkgs; [
        vlc
        obs-studio
        telegram-desktop
        gimp
        # obsidian
        vesktop
        onlyoffice-desktopeditors
        cliamp
        anki-bin
        digikam
        element-desktop
        jellyfin-desktop
        feishin
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
      # virtualisation
      servarr
      media-server
      music-toolkit

      # Host-specific modules
      archmagosSSH
      org-backup
      archmagosHardware # Always keep this one!
    ];

    environment.systemPackages = with pkgs; [
      emacs
      qbittorrent
      exfat
      warehouse
      darktable
      udiskie
      naps2
      tree-sitter
      gcc
      sqlite
      pandoc
      wl-clipboard
      sddm-astronaut
      dmidecode
      filezilla
      winboat
      waydroid-helper
      winbox
      fontconfig
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.dvr-patched.packages.${pkgs.stdenv.hostPlatform.system}.default
      calibre
      kdePackages.okular
      halloy
      librewolf
      firefox
      imv
      mpv
      noctalia
    ];

    fonts.packages = [
      pkgs.monocraft
   #   pkgs.corefonts
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

    fonts.fontDir.enable = true;

    programs.amnezia-vpn.enable = true;
    programs.throne = {
      enable = true;
      tunMode.enable = true;
    };

    # ========================= #
    # === FILESYSTEM MOUNTS === #
    # ========================= #

    # NAS mount
    # boot.supportedFilesystems = [ "nfs" ];
    # services.rpcbind.enable = true;

    # fileSystems."/mnt/warehouse" = {
      # device = "192.168.1.10:/nfs/warehouse";
      # fsType = "nfs";
      # options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=60" ];
    # };

    # ====================== #
    # === SHELL SETTINGS === #
    # ====================== #

    # programs.zsh.enable = true;
    # users.defaultUserShell = pkgs.zsh;

    programs.fish.shellAliases = {
      # winboot = "sudo bootctl set-oneshot auto-windows && reboot";
      rebuild = "sudo nixos-rebuild switch --flake /home/cypher/nixconf#archmagos";
      niri-displayfix = "niri msg output HDMI-A-2 mode 2560x1440@143.996";
    };

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 11345 4544 ];

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

    services.paperless = {
      enable = false;
      port = 8380;
    };

    services.udisks2.enable = true;

    services.printing.enable = false;
    hardware.sane.enable = false;
    services.avahi.enable = false;
    services.avahi.nssmdns4 = false;

    # Allow Git to push from mounted NAS
    # environment.etc."gitconfig".text = ''
    #   [safe]
    #     directory = /mnt/nas/games/installers
    # '';

    programs.labwc.enable = false;

    programs.yazi.enable = true;
    programs.lazygit.enable = true;

    services.flatpak.enable = true;
    services.lact.enable = true;

    programs.thunderbird.enable = true;
    services.protonmail-bridge.enable = true;

    xdg.mime.defaultApplications = {
      "application/pdf" = "okularApplication_pdf.desktop";
    };

    nixpkgs.config.problems.handlers = {
             "gtk+".broken = "warn"; # or "ignore"
           }; # remove when possible

    system.stateVersion = "26.05"; # Do not touch!
  };
}
