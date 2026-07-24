{ self, inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    packages.myEnvironment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.myFish;
      runtimeInputs = [
        selfpkgs.myNeovim
        pkgs.wget
        selfpkgs.myFastfetch
        pkgs.tmux
        pkgs.zellij
        pkgs.rsync
        pkgs.btop
        pkgs.tree
        pkgs.nmap
        pkgs.psmisc
        pkgs.ripgrep
        pkgs.fd
        pkgs.ffmpeg-full
      ];
      env = {
        EDITOR = "nvim";
      };
    };
  };

}
