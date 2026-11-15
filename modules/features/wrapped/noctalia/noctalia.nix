{ inputs, ... }: {

  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.noctalia;
      env.NOCTALIA_CONFIG_HOME = "${pkgs.linkFarm "noctalia-config-home" {
        "noctalia/config.toml" = ./config.toml;
      }}";
    };
  };

}
