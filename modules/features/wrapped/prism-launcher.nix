{ inputs, lib, ... }: {

  perSystem = { pkgs, self', ... }: {
    packages.myPrismLauncher = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.prismlauncher;
      jdks = [
        graalvmPackages.graalvm-ce
	jdk21
      ];
    };
  };

}
