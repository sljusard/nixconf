{ self, inputs, ... }: {

  flake.nixosModules.noosphereSSH = { pkgs, lib, ... }: {
    services.openssh.settings.AllowUsers = [ "cypher" ];
    users.users."cypher".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM2rF0pyN4Lhi0H5NlmzZbcSLfVjA0OTECJ09Cs2SAJ cypher@noosphere"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnGmH1a6uqbhlToNGW/tCt1nVoWEQWxpQZB6gft4vXM u0_a230"
    ];

    programs.ssh = {
      extraConfig = "
        Host ecoserver
          Hostname 217.114.188.94
          Port 4572
          User sljusard
          SetEnv TERM=xterm-256color

        Host vpnserver
          Hostname 132.243.254.68
          Port 22
          User root
     ";
     startAgent = true;
    };
    
    services.gnome.gcr-ssh-agent.enable = false;
  };

}
