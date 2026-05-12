{ config, pkgs, lib, ... }: {

  flake.nixosModules.podman = { pkgs, lib, ... }: {
    virtualisation.containers.enable = true;
    virtualisation.podman.enable = true;
    virtualisation.podman = {
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      dive
      podman-tui
      podman-compose
    ];
  };

}
