{ self, inputs, ... }: {

  flake.nixosModules.myNeovim = { pkgs, lib, ... }: {
    config = {
      settings.config_directory = ./.;
      settings.aliases = [ 
      	"vim"
				"vi"
				"v"
				"emacssucks"
      ];
    };
  };

  perSystem = { pkgs, self', ... }: {
    packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      imports = [
        self.nixosModules.myNeovim
      ];
    };
  };

}
