{ config, pkgs, lib, ... }: {

  flake.nixosModules.podman = { pkgs, lib, ... }: {
    virtualisation.containers.enable = true;
    virtualisation.docker.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = false;
      dockerSocket.enable = false;
      defaultNetwork.settings.dns_enabled = true;
    };

    environment.systemPackages = with pkgs; [
      dive
      distrobox
      distrobox-tui
      podman-tui
      podman-compose
    ];
  };

}
