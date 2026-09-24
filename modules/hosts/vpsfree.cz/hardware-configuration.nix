{ self, inputs, ... }: {

  flake.nixosModules.pragueAlphaHardware = { config, lib, pkgs, modulesPath, ... }: {
  imports = [ ];
  
  networking.hostId = "007f0200";
  boot.initrd.availableKernelModules = [ "megaraid_sas" "xhci_pci" "ahci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "tank/ct/29992";
      fsType = "zfs";
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";  
  };

}
