{ self, inputs, ... }: {

  flake.nixosModules.myGit = { pkgs, lib, config, ... }: {
    config = {
      settings = {
        user.name = "Denis Slyusar";
        user.email = "sljusarde@gmail.com";
        init.defaultBranch = "main";
      };
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myGit];
    };
  };

}
