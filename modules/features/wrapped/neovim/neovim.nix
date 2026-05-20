{ self, inputs, ... }: {

  flake.nixosModules.myNeovim = { config, wlib, pkgs, lib, ... }: {
    config = {
      settings.config_directory = ./.;
      settings.aliases = [ 
      	"vim"
			  "vi"
				"emacssucks"
      ];
      
#      specs.init = {
#        data = null;
#        before = ["MAIN_INIT"];
#        config = "require('init')";
#      };

#      specs.general = {
#        data = with pkgs.vimPlugins; [
#          lz-n
#          oil-nvim
#        ];
#      };
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
