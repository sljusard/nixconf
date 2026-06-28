{ self, inputs, lib, ... }: {

  flake.nixosModules.myRofiConfig = { pkgs, config, ... }: {
    config = {
      "config.rasi".path = ./config.rasi;
    };
  };

  perSystem = { pkgs, self', ... }: {
    packages.myRofi = inputs.wrapper-modules.wrappers.rofi.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myRofiConfig];
    };
  };

}
