{ self, inputs, ... }: {

  flake.nixosModules.archmagosSSH = { pkgs, lib, ... }: {
    services.openssh.settings.AllowUsers = [ "cypher" ];
    users.users."cypher".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM2rF0pyN4Lhi0H5NlmzZbcSLfVjA0OTECJ09Cs2SAJ cypher@noosphere"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnGmH1a6uqbhlToNGW/tCt1nVoWEQWxpQZB6gft4vXM u0_a230"
    ];

    programs.ssh = {
      extraConfig = "
        Host ecoserver
          Hostname 192.168.88.63
          Port 4572
          User sljusard
          SetEnv TERM=xterm-256color

        Host lexmechanic
          Hostname 192.168.88.62
          Port 4572
          User cypher
          SetEnv TERM=xterm-256color

        Host ecoserver-remote
          Hostname 5.53.17.101
          Port 4572
          User sljusard
          SetEnv TERM=xterm-256color

        Host prague-alpha
          Hostname 37.205.15.215
          Port 4572
          User sljusard
          SetEnv TERM=xterm-256color

        Host hetzner-box-1
          Hostname u645105.your-storagebox.de
          Port 23
          User u645105
          ProxyJump prague-alpha
     ";
     startAgent = true;
    };
    
    services.gnome.gcr-ssh-agent.enable = false;
  };

}
