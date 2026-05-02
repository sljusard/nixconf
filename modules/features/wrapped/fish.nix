{ self, inputs, lib, ... }: {

  flake.nixosModules.myFishConfig = { pkgs, config, ... }: {
    config = {
      configFile.content = ''
        set fish_greeting
        ${lib.getExe pkgs.zoxide} init fish | source
      '';
    };
  };

  perSystem = { pkgs, self', ... }: {
    packages.myFish = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myFishConfig];
      extraPackages = with pkgs; [
        zoxide
      ];
      flags = {
        "--no-config" = lib.mkForce false;
      };
    };
  };

}
