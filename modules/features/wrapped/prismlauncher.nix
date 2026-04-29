{ inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: {
    packages.myPrismLauncher = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = (pkgs.prismlauncher.override {
        jdks = with pkgs; [
          graalvmPackages.graalvm-ce
	  jdk21
        ];
      });
    };
  };

}
