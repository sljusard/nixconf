{ self, inputs, ... }: {

  perSystem = { pkgs, ... }: {
    packages.myFastfetch = inputs.wrapper-modules.wrappers.fastfetch.wrap {
      inherit pkgs;
      settings = builtins.fromJSON (builtins.readFile ./fastfetch.json);
    };
  };

}
