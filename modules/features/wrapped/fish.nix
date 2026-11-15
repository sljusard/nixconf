{ self, inputs, lib, ... }: {

  flake.nixosModules.myFishConfig = { pkgs, config, ... }: let
    # Each new interactive shell prints one of these at random
    greetings = [
      "There is no place like 127.0.0.1"
      "Welcome back!"
      "Linux larpmaxxing"
      "No more ranked for me dawg"
    ];
  in {
    config = {
      configFile.content = ''
        function fish_greeting
          set_color ff8700
          echo (random choice ${lib.escapeShellArgs greetings})
          set_color normal
        end
        ${lib.getExe pkgs.zoxide} init fish | source
      '';
      # Hand interactive bash sessions over to fish
      constructFiles.bashHandoff = {
        relPath = "etc/bash_completion.d/fish-handoff.sh";
        content = ''
          __fish_bin="''${BASH_SOURCE[0]%/etc/bash_completion.d/*}/bin/fish"
          if [[ -x $__fish_bin && $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
          then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec "$__fish_bin" $LOGIN_OPTION
          fi
          unset __fish_bin
        '';
      };
    };
  };

  perSystem = { pkgs, self', ... }: {
    packages.myFish = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myFishConfig];
      runtimePkgs = with pkgs; [
        zoxide
      ];
      flags = {
        "--no-config" = lib.mkForce false;
      };
    };
  };

}
