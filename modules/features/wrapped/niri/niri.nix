{ self, inputs, ... }: {

  flake.nixosModules.myNiri = { pkgs, lib, config, ... }: {
    config = {
      settings = let
        rofiExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myRofi;
        footExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myFoot;
        screenshotEditExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.screenshot-edit; # Declared in screenshots.nix
      in {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        spawn-at-startup = [ (lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myNoctalia) ];

        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-wallpaper"; } ];
            place-within-backdrop = true;
          }
        ];

        binds = {
          "Mod+Return".spawn-sh = footExe;
          "Mod+T".spawn-sh = footExe;
          "Mod+S".spawn-sh = "${rofiExe} -show drun";
          "Ctrl+F12".spawn-sh = screenshotEditExe;
        };
      };

      extraSettings = [
        { include = ./config.kdl; }
        { include = ./keybinds.kdl; }
        { include = ./outputs.kdl; }
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
