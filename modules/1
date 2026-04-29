{ self, inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: {
    packages.myShell = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.myFish;
      runtimeInputs = [
        pkgs.wget
	pkgs.fastfetch
	pkgs.tmux
	pkgs.rsync
	pkgs.btop
	pkgs.tree
	pkgs.nmap
	pkgs.psmisc
	pkgs.ffmpeg-full
      ];
      env = {
        EDITOR = "nvim";
      };
    };
  };

}
