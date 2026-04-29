{ self, inputs, ... }: {

  flake.nixosModules.neovim = { pkgs, lib, ... }: {
    programs.neovim.enable = true;
    programs.neovim.package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim;
    programs.neovim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    
    packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
    };

  }; 

}
