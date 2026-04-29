{ self, inputs, ... }: {

  flake.nixosModules.kde-plasma = { pkgs, lib, ... }: {

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs; [
      kdePackages.elisa
      kdePackages.kate
      kdePackages.konsole
      kdePackages.kwalletmanager
      kdePackages.qrca
    ];

  }; 

}
