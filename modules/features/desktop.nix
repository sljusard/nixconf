{ self, inputs, ... }: {

  flake.nixosModules.desktop = { config, pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    programs.niri.enable = true;
    programs.niri.package = selfpkgs.myNiri; # Declared in niri/niri.nix

    programs.mango.enable = false;
    programs.mango.package = selfpkgs.myMango; # Declared in mango/mango.nix
    systemd.packages = [ selfpkgs.myMango ]; # mango hot-reload user service

    services.displayManager.defaultSession = lib.head config.programs.niri.package.providedSessions;
    services.displayManager.sddm = let
      sddmTheme = pkgs.where-is-my-sddm-theme;
    in {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      extraPackages = [ sddmTheme ];
      theme = "${sddmTheme}/share/sddm/themes/where_is_my_sddm_theme";
    };

    programs.noctalia.enable = true;
    programs.noctalia.package = selfpkgs.myNoctalia; # Declared in noctalia/noctalia.nix

    programs.fish.enable = true;
    programs.fish.package = selfpkgs.myEnvironment; # Declared in environment.nix

    programs.git.enable = true;
    programs.git.package = selfpkgs.myGit; # Declared in git.nix

    environment.systemPackages = [
      # selfpkgs.myAlacritty
      selfpkgs.myFoot # Declared in foot.nix
      selfpkgs.myRofi # Declared in rofi/rofi.nix
    ];
  };

}
