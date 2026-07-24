{ self, inputs, ... }: {

  flake.nixosModules.myTmux = { pkgs, lib, config, ... }: {
    config = {
      configAfter = builtins.readFile ./tmux.conf;
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myTmux = inputs.wrapper-modules.wrappers.tmux.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myTmux];
    };
  };

}
