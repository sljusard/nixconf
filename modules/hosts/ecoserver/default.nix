{ self, inputs, config, ... }: {
  
  flake.nixosConfigurations.ecoserver = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.ecoserverConfiguration
    ];
  };

}
