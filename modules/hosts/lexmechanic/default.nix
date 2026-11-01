{ self, inputs, config, ... }: {
  
  flake.nixosConfigurations.lexmechanic = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.lexmechanicConfiguration
    ];
  };

}
