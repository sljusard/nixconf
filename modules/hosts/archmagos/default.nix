{ self, inputs, config, ... }: {
  
  flake.nixosConfigurations.archmagos = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.archmagosConfiguration
    ];
  };

}
