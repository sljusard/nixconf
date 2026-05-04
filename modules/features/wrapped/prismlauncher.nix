{ inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: {
    packages.myPrismLauncher = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = (pkgs.prismlauncher.override {
        jdks = with pkgs; [
          graalvmPackages.graalvm-ce
	  temurin-bin-21
	  jdk21
	  jdk25
        ];
      });
    };
  };

}
