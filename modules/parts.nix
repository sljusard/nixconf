{ inputs, ... }:

{
#  imports = [
#    inputs.flake-parts.flakeModules.modules
#    inputs.wrapper-modules.flakeModules.wrappers
#  ];

#  options = {
#    flake = inputs.flake-parts.lib.mkSubmoduleOptions {
#      wrapperModules = inputs.nixpkgs.lib.mkOption {
#        default = {};
#      };
#    };
#  };

  config = {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    # Allow unfree packages in wrapped packages
    perSystem = { system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
  };
}
