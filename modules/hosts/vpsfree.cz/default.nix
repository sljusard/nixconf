{ self, inputs, config, ... }: {
  
  flake.nixosConfigurations.prague-alpha = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.pragueAlphaConfiguration
    ];
  };

}
