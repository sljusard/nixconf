{ self, inputs, ... }: {

  flake.nixosModules.myMango = { pkgs, lib, config, ... }: {
    config = {
      sourcedFiles = [ ./config.conf ];

      settings = let
        rofiExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myRofi;
        footExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myFoot;
      in {
        exec = [ "noctalia" ];

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
