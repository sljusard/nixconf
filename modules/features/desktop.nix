{ self, inputs, ... }: {

  flake.nixosModules.myDesktop = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    programs.niri.enable = true;
    programs.niri.package = selfpkgs.myNiri; # Declared in niri.nix

    programs.fish.enable = true;
    programs.fish.package = selfpkgs.myEnvironment; # Declared in environment.nix

    programs.git.enable = true;
    programs.git.package = selfpkgs.myGit; # Declared in git.nix

    environment.systemPackages = [
      selfpkgs.myAlacritty # Declared in alacritty.nix
      selfpkgs.myFoot # Declared in foot.nix
    ];
  };

}
