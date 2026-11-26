{ config, pkgs, lib, ... }: {

  flake.nixosModules.media-server = { pkgs, lib, ... }: {

    users.groups.media = {};

    services.navidrome = {
      enable = true;
      settings.Port = 4544;
      settings.MusicFolder = "/mnt/warehouse/media/music";
      settings.Address = "0.0.0.0";
    };

    services.jellyfin = {
      enable = true;
      group = "media";
    };
  };

}
