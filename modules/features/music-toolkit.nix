{ self, inputs, ... }: {

  flake.nixosModules.music-toolkit = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    environment.systemPackages = [
      pkgs.dr14_tmeter
      pkgs.spek
      pkgs.picard
      pkgs.rsgain
    ];
  };

}
