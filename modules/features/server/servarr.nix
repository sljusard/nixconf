{ config, pkgs, lib, ... }: {

  flake.nixosModules.servarr = { pkgs, lib, ... }: {
    users.groups.media = {};

    services.prowlarr = {
      enable = true;
      settings.server.port = 9600;
      openFirewall = false;
    };

    services.lidarr = {
      enable = true;
      settings.server.port = 9610;
      openFirewall = true;
      group = "media";
    };

    services.flaresolverr = {
      enable = true;
      port = 9601;
      openFirewall = false;
    };
  };

}
