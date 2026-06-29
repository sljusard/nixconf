{ self, inputs, ... }: {

  flake.nixosModules.myNiri = { pkgs, lib, config, ... }: {
    config = {
      settings = let
        noctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myNoctalia;
        rofiExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myRofi;
        # alacrittyExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myAlacritty;
	      footExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.myFoot;
      in {
        spawn-at-startup = [
          noctaliaExe
         ];
        
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        prefer-no-csd = _: {};

        input = {
	        keyboard = {
	          xkb = {
	            layout = "us,ru";
	            variant = "colemak,";
	            options = "
	              grp:alt_shift_toggle,
	              compose:rctrl
	            ";
	          };

            repeat-rate = 40;
	          repeat-delay = 250;
	      };

	      touchpad = {
	        natural-scroll = _: {};
	        tap = _: {};
	      };

	      mouse = {
	        accel-profile = "flat";
	      };
      };

      layout = {
	      gaps = 5;
	      focus-ring = {
	        width = 2;
        };
      };
        
      binds = let
        n = _: {};
      in {
          "Mod+Return".spawn-sh = footExe;
          "Mod+S".spawn-sh = "${rofiExe} -show drun";

      #	  "Ctrl+Alt+1".switch-layout = "0";
      #	  "Ctrl+Alt+2".switch-layout = "1";
      #	  "Ctrl+Alt+3".switch-layout = "2";

          "Mod+Q".close-window = n;
          "Mod+F".maximize-column = n;
	        "Mod+G".fullscreen-window = n;
          "Mod+C".center-column = n;
          "Mod+Shift+F".toggle-window-floating = n;

          "Mod+Left".focus-column-left = n;
          "Mod+Right".focus-column-right = n;
          "Mod+Up".focus-window-up = n;
          "Mod+Down".focus-window-down = n;

          "Mod+Shift+Left".move-column-left = n;
          "Mod+Shift+Right".move-column-right = n;
          "Mod+Shift+Up".move-window-up = n;
          "Mod+Shift+Down".move-window-down = n;
          "Mod+Ctrl+Left".consume-or-expel-window-left = n;
          "Mod+Ctrl+Right".consume-or-expel-window-right = n;

          "Mod+Page_Up".focus-workspace-up = n;
          "Mod+Page_Down".focus-workspace-down = n;
          
          "Mod+Shift+Page_Up".move-column-to-workspace-up = n;
          "Mod+Shift+Page_Down".move-column-to-workspace-down = n;

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;
          "Mod+0".focus-workspace = 10;

          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
          "Mod+Shift+6".move-column-to-workspace = 6;
          "Mod+Shift+7".move-column-to-workspace = 7;
          "Mod+Shift+8".move-column-to-workspace = 8;
          "Mod+Shift+9".move-column-to-workspace = 9;
          "Mod+Shift+0".move-column-to-workspace = 10;

          "Mod+WheelScrollDown".focus-column-left = n;
          "Mod+WheelScrollUp".focus-column-right = n;
          "Mod+Shift+WheelScrollDown".focus-workspace-down = n;
          "Mod+Shift+WheelScrollUp".focus-workspace-up = n;

          "Mod+Ctrl+Page_Up".move-workspace-to-monitor-next = n;

          "F12".screenshot-screen = n;
          "Ctrl+F12".screenshot = n;
          "Shift+F12".screenshot-window = n;
        };
      };
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myNiri];
    };
  };

}
