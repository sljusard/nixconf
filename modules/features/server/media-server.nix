{ config, pkgs, lib, ... }: {

  flake.nixosModules.media-server = { pkgs, lib, ... }: {
    services.navidrome = {
      enable = true;
      settings.Port = 4544;
      settings.MusicFolder = "/mnt/warehouse/music";
      settings.Address = "192.168.1.111";
    };

    services.jellyfin = {
      enable = true;
      group = "media";
    };
  };

}
