{ self, inputs, ... }: {

  flake.nixosModules.ecoserverSSH = { pkgs, lib, ... }: {
    services.openssh.settings.AllowUsers = [ "sljusard" ];
    users.users."sljusard".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBM2rF0pyN4Lhi0H5NlmzZbcSLfVjA0OTECJ09Cs2SAJ cypher@noosphere"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBnGmH1a6uqbhlToNGW/tCt1nVoWEQWxpQZB6gft4vXM u0_a230"
    ];
  };

}
