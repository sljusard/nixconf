{ self, inputs, ... }: {

  flake.nixosModules.ssh = { pkgs, lib, ... }: {
    services.openssh = {
      enable = true;
      ports = [ 4572 ];
      settings = {
        PermitRootLogin = "no";
        AllowUsers = [ "cypher" ];
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users."cypher".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkcU2ppKWy/YE/juej0f7zZeXxQ5mLqW5nAPofmvmPC cypher"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM2rF0pyN4Lhi0H5NlmzZbcSLfVjA0OTECJ09Cs2SAJ cypher@noosphere"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnGmH1a6uqbhlToNGW/tCt1nVoWEQWxpQZB6gft4vXM u0_a230"
    ];

    services.fail2ban = {
      enable = true;
      maxretry = 3;
      bantime = "24h";
      bantime-increment = {
        multipliers = "1 2 4 7";
        maxtime = "168h";
        overalljails = true;
      };
    };

    services.endlessh = {
      enable = true;
      port = 22;
      openFirewall = true;
    };
  };

}
