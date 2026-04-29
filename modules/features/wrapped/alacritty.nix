{ self, inputs, ... }: {

  flake.nixosModules.myAlacritty = { pkgs, lib, config, ... }: {
    config = {
      settings = {
        general.live_config_reload = true;
        window.opacity = 0.7;
        window.blur = true;
        mouse.hide_when_typing = true;
      };
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myAlacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myAlacritty];
    };
  };

}
