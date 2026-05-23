{ self, inputs, lib, pkgs, ... }: {

  flake.nixosModules.myFoot = { pkgs, config, ... }: {
    config = {
      settings = {
        mouse.hide-when-typing = "yes";
        main.font = "BlexMono Nerd Font:size=11.25";
#        main.font = "JetBrainsMono Nerd Font:size=11.25";
#        main.font = "Monocraft:size=12";
        colors-dark = {
          background = "181818";
          alpha = "0.7";
          blur = "yes";
        };
      };
    };
  };

  perSystem = { pkgs, self', config, ... }: {
    packages.myFoot = inputs.wrapper-modules.wrappers.foot.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myFoot];
      settings = let
        shellExe = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myEnvironment;
      in { main.shell = shellExe; };
    };
  };

}
