{ self, inputs, ... }: {

  flake.nixosModules.virtualisation = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    environment.systemPackages = [
      pkgs.qemu
      pkgs.quickemu
    ];

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };

}
