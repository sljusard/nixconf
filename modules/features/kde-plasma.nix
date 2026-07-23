{ self, inputs, ... }: {

  flake.nixosModules.kde-plasma = { pkgs, lib, ... }: {
    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      ark
      dolphin
      elisa
      gwenview
      kate
      kcalc
      khelpcenter
      konsole
      okular
      spectacle
      discover
      kdeconnect-kde
      kdegraphics-thumbnailers
      kdenetwork-filesharing
      ffmpegthumbs
      plasma-browser-integration
      plasma-vault
      print-manager
      kwrited
      krdp
      kinfocenter
      plasma-systemmonitor
    ];

  }; 

}
