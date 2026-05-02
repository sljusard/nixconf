{ self, inputs, lib, ... }: {

  flake.nixosModules.myFishRewrite = { pkgs, config, ... }: {
    config = {
      configFile.content = ''
        ${lib.getExe pkgs.zoxide} init fish | source

	set -g fish_color_normal normal
        set -g fish_color_command green
        set -g fish_color_param cyan
        set -g fish_color_redirection normal
        set -g fish_color_comment red
        set -g fish_color_error red --bold
        set -g fish_color_escape cyan
        set -g fish_color_operator cyan
        set -g fish_color_end cyan
        set -g fish_color_quote brown
        set -g fish_color_valid_path --underline
        set -g fish_color_search_match --background=purple
        set -g fish_color_selection --background=purple
        set -g fish_color_history_current --bold
        set -g fish_color_cwd green
        set -g fish_color_cwd_root red
        set -g fish_color_match --background=brblue
        set -g fish_color_user brgreen
        set -g fish_color_host normal
        set -g fish_color_cancel -r
      '';
    };
  };

  perSystem = { pkgs, self', ... }: {
    packages.myFishRewrite = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myFishRewrite];
      extraPackages = with pkgs; [
        zoxide
      ];
      flags = {
        "-i" = true;
      };
    };
  };

}
