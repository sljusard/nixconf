{ self, inputs, config, ... }: {
  
  flake.nixosConfigurations.noosphere = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.noosphereConfiguration
    ];
  };

}
