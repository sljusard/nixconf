{ self, inputs, ... }: {

  flake.nixosModules.myMango = { pkgs, lib, config, ... }: {
    config = {
      sourcedFiles = [ ./config.conf ];

      # Reloads mango with the new config on nixos-rebuild switch.
      # The unit is installed via systemd.packages in desktop.nix.
      hotReload.enable = true;

      settings = let
        rofiExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myRofi;
        footExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myFoot;
      in {
        exec = [ "noctalia" ];
        exec_once = [ "systemctl --user start mangoReloadConfig.service" ];

        bind = [
          "super,return,spawn,${footExe}"
          "super,code:28,spawn,${footExe}"
          "super,code:39,spawn,${rofiExe} -show drun"
        ];
      };
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myMango = inputs.wrapper-modules.wrappers.mangowc.wrap {
      inherit pkgs;
      imports = [ self.nixosModules.myMango ];
    };
  };

}
