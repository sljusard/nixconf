{ self, inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: {
    packages.myEnvironment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.myFishRewrite;
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
