{ inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: let
    fishConfig = 
      pkgs.writeText "fish.conf"
      ''
        ${lib.getExe pkgs.zoxide} init fish | source
      '';
  in {
    packages.myFish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimeInputs = [
        pkgs.zoxide
      ];
      flags = {
        "-C" = "source ${fishConfig}";
      };
    };
  };

}
