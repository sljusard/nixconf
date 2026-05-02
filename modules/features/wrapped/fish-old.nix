{ inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: let
    fishConfig = 
      pkgs.writeText "fish.conf"
      ''
        set fish_greeting
        ${lib.getExe pkgs.zoxide} init fish | source
      '';
  in {
    packages.myFishOld = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimeInputs = with pkgs; [
        zoxide
      ];
      flags = {
        "-C" = "source ${fishConfig}";
      };
    };
  };

}
