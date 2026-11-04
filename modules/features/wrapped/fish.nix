{ self, inputs, lib, ... }: {

  flake.nixosModules.myFishConfig = { pkgs, config, ... }: {
    config = {
      configFile.content = ''
        set fish_greeting
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
