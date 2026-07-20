{ self, inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: {
    packages.myTerminal = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.myFish;
      runtimeInputs = [
        pkgs.wget
        self'.packages.myFastfetch
        pkgs.tmux
        pkgs.rsync
        pkgs.btop
        pkgs.tree
        pkgs.nmap
        pkgs.psmisc
        pkgs.ffmpeg-full
      ];
    };
  };

}
