{ self, inputs, ... }: {

  flake.nixosModules.gaming = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
      # gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    environment.systemPackages = [
      selfpkgs.myPrismLauncher # Declared in prismlauncher.nix
      pkgs.mangohud
      pkgs.protonplus
#      pkgs.steamcmd
#      pkgs.steam-tui
      pkgs.heroic
    ];
  };
  
}
