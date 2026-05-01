{ self, inputs, ... }: {

  flake.nixosModules.passwords = { pkgs, lib, ... }: {
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      settings.default-cache-ttl = 300;
    };

    environment.systemPackages = with pkgs; [
      pass
      passExtensions.pass-otp
      gopass
    ];
  };
  
}
