{ self, inputs, ... }: {

  flake.nixosModules.passwords = { pkgs, lib, ... }: {
    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      settings.default-cache-ttl = 300;
    };

    environment.systemPackages = [
      (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))
      pkgs.gopass
    ];
  };
  
}
