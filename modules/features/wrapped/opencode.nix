{ self, inputs, ... }: {

  flake.nixosModules.myOpencode = { pkgs, lib, config, ... }: {
    config = {
      settings = {
        permission = {
          edit = "ask";
          bash = "ask";
        };
      };
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myOpencode = inputs.wrapper-modules.wrappers.opencode.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myOpencode];
    };
  };

}
