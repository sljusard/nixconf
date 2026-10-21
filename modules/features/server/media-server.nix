{ config, pkgs, lib, ... }: {

  flake.nixosModules.media-server = { pkgs, lib, ... }: {
    services.navidrome = {
      enable = true;
      settings.Port = 4544;
      settings.MusicFolder = "/mnt/storage/data/media/music";
      settings.Address = "127.0.0.1";
    };

    services.jellyfin = {
      enable = true;
      group = "media";
    };
  };

}
