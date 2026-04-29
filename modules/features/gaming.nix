{ self, inputs, ... }: {

  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    # imports = [
    #  inputs.home-manager.flakeModules.home-manager
    # ];

    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
      # gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

#    xdg.desktopEntries.steam = {
#      name = "Steam";
#      type = "Application";
#      comment = "Лучший игровой магазин и лаунчер на планете";
#      categories = [ "Games" ];
#      exec = "steam --system-compositor";
#    };
    
    environment.systemPackages = with pkgs; [
      prismlauncher
      mangohud
      protonplus
    ];

  };
  
}
