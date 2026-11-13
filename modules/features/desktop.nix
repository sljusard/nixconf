{ self, inputs, ... }: {

  flake.nixosModules.desktop = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    programs.niri.enable = true;
    programs.niri.package = selfpkgs.myNiri; # Declared in niri/niri.nix

    programs.mango.enable = true;
    programs.mango.package = selfpkgs.myMango; # Declared in mango/mango.nix
    systemd.packages = [ selfpkgs.myMango ]; # mango hot-reload user service

    programs.noctalia.enable = true;
    programs.noctalia.systemd.enable = true; # Use systemd for noctalia auto-start instead of WM exec

    programs.fish.enable = true;
    programs.fish.package = selfpkgs.myEnvironment; # Declared in environment.nix

    programs.git.enable = true;
    programs.git.package = selfpkgs.myGit; # Declared in git.nix

    environment.systemPackages = [
      # selfpkgs.myAlacritty
      selfpkgs.myFoot # Declared in foot.nix
      selfpkgs.myRofi # Declared in rofi/rofi.nix
    ];
  };

}
