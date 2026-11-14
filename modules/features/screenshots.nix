{ self, inputs, lib, ... }: {

  perSystem = { pkgs, ... }: let
    # Builds a screenshot command.
    #   area = false -> capture the entire screen
    #   area = true  -> freeze the screen and select a region with slurp
    #   edit = true  -> open the capture in satty instead of copying it
    mkShot = { name, area ? false, edit ? false }: pkgs.writeShellApplication {
      inherit name;
      runtimeInputs = with pkgs; [
        grim
        slurp
        wl-clipboard
        satty
        wayfreeze
        procps
        coreutils
      ];
      text = ''
        dir="$HOME/Pictures/Screenshots"
        mkdir -p "$dir"
        file="$dir/$(date +%Y%m%d%H%M%S)-screenshot.png"
      '' + (if area then ''
        # grim runs while the screen is still frozen, so the frozen frame is captured
        wayfreeze --after-freeze-cmd "slurp | grim -g - '$file'; pkill -x wayfreeze" || true
        # Selection cancelled -> nothing to save
        if [ ! -s "$file" ]; then
          rm -f "$file"
          exit 1
        fi
      '' else ''
        grim "$file"
      '') + (if edit then ''
        satty --filename "$file" --output-filename "$file" --copy-command wl-copy --early-exit ${
          if area
          # Small selection: keep a normal (floating) window
          then "--floating-hack"
          # Full screen: open on top of the desktop like an overlay
          else "--fullscreen current-screen --no-window-decoration --initial-tool crop"
        }
      '' else ''
        wl-copy --type image/png < "$file"
      '');
    };
  in {
    packages.screenshot-full      = mkShot { name = "screenshot-full"; };
    packages.screenshot-area      = mkShot { name = "screenshot-area"; area = true; };
    packages.screenshot-full-edit = mkShot { name = "screenshot-full-edit"; edit = true; };
    packages.screenshot-area-edit = mkShot { name = "screenshot-area-edit"; area = true; edit = true; };
  };

  flake.nixosModules.screenshots = { pkgs, lib, ... }: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    environment.systemPackages = [
      selfpkgs.screenshot-full
      selfpkgs.screenshot-area
      selfpkgs.screenshot-full-edit
      selfpkgs.screenshot-area-edit
    ] ++ (with pkgs; [
      grim
      slurp
      wl-clipboard
      satty
      wayfreeze
    ]);
  };

}
