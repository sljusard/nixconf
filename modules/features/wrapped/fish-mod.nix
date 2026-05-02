{ self, inputs, lib, ... }: {

  flake.nixosModules.myFishRewrite = { pkgs, config, ... }: {
    config = {
      configFile.content = ''
        ${lib.getExe pkgs.zoxide} init fish | source
      '';
    };
  };

  perSystem = { pkgs, self', ... }: {
    packages.myFishRewrite = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myFishRewrite];
      extraPackages = with pkgs; [
        zoxide
      ];
      flags = {
        "--no-config" = lib.mkForce false;
      };
    };
  };

}
