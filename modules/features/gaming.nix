{ self, inputs, ... }: {

  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
      # gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      prismlauncher
      mangohud
      protonplus
    ];

  };
  
}
