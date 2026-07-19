{ self, inputs, ... }: {

  flake.nixosModules.myNiri = { pkgs, lib, config, ... }: {
    config = {
      settings = let
        noctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myNoctalia;
        rofiExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myRofi;
        footExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myFoot;
      in {
        spawn-at-startup = [
          noctaliaExe
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-wallpaper"; } ];
            place-within-backdrop = true;
          }
        ];

        binds = {
          "Mod+Return".spawn-sh = footExe;
          "Mod+S".spawn-sh = "${rofiExe} -show drun";
        };
      };

      extraSettings = [
        { include = ./config.kdl; }
      ];
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myNiri];
    };
  };

}
