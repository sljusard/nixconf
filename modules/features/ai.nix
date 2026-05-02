{ self, inputs, ... }: {

  flake.nixosModules.ai = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    environment.systemPackages = [
      selfpkgs.myOpencode
      pkgs.claude-code
    ];
  };

}
