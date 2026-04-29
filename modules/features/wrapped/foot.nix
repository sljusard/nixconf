{ self, inputs, lib, pkgs, ... }: {

  flake.nixosModules.myFoot = { pkgs, config, ... }: {
    config = {
        settings = let
	  fishExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myFish;
	in {
        mouse.hide-when-typing = "yes";
        main.font = "BlexMono Nerd Font:size=11.25";
        colors-dark = {
          background = "181818";
          alpha = "0.7";
          blur = "no";
        };
      };
    };
  };

  perSystem = { pkgs, self', config, ... }: {
    packages.myFoot = inputs.wrapper-modules.wrappers.foot.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myFoot];
      settings = let
        fishExe = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myShell;
      in { main.shell = fishExe; };
    };
  };

}
