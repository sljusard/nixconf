{ self, inputs, lib, ... }: {

  perSystem = { pkgs, ... }: let
    # Builds a full screen screenshot command.
    #   edit = false -> copy the capture to the clipboard
    #   edit = true  -> open the capture in satty (Ctrl+C there copies it)
    mkShot = { name, edit ? false }: pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [
        grim
        wl-clipboard
        satty
        libnotify
        coreutils
      ];
      text = ''
        dir="$HOME/Pictures/Screenshots"
        mkdir -p "$dir"
        file="$dir/$(date +%Y%m%d%H%M%S)-screenshot.png"
        grim "$file"
      '' + (if edit then ''
        # Opens on top of the desktop like an overlay (see mango/windowrules.conf)
        satty --filename "$file" --output-filename "$file" --copy-command wl-copy --early-exit \
          --fullscreen current-screen --no-window-decoration --initial-tool crop
      '' else ''
        wl-copy --type image/png < "$file"
        notify-send -a "Screenshot" -i "$file" "Screenshot taken" "Saved to $file and copied to clipboard"
      '');
    };
  in {
    packages.screenshot      = mkShot { name = "screenshot"; };
    packages.screenshot-edit = mkShot { name = "screenshot-edit"; edit = true; };
  };

  flake.nixosModules.screenshots = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    environment.systemPackages = [
      selfpkgs.screenshot
      selfpkgs.screenshot-edit
    ] ++ (with pkgs; [
      grim
      wl-clipboard
      satty
    ]);
  };

}
