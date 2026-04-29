{ self, inputs, ... }: {

  flake.nixosModules.obsidian = { pkgs, lib, ... }: {
  
    programs.obsidian.enable = true;

  }; 

}
