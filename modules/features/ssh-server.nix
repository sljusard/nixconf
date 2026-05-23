{ self, inputs, ... }: {

  flake.nixosModules.ssh = { pkgs, lib, ... }: {
    services.openssh = {
      enable = true;
      ports = [ 4572 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

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
