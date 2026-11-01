{ self, inputs, ... }: {

  flake.nixosModules.noosphereHardware = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = { 
      device = "/dev/disk/by-uuid/58a5b46b-0de1-4ebc-855b-d0b803498705";
      fsType = "ext4";
    };

    fileSystems."/boot" = { 
      device = "/dev/disk/by-uuid/7A3D-4C38";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [ 
      { device = "/dev/disk/by-uuid/47858d93-3103-47b9-b5e6-82414f108de0"; }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

}
