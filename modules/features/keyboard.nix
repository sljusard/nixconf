{ self, inputs, ... }: {

  # XKB ring includes Colemak and Russian layouts;
  # QWERTY is invoked via holding Super key considering all WM keybinds will use Super key (Kanata)
  flake.nixosModules.keyboard = { ... }: {
    services.xserver.xkb = {
      layout = "us,ru";
      variant = "colemak,";
      options = "grp:alt_shift_toggle,compose:rctrl";
    };

    services.kanata = {
      enable = true;
      keyboards.main = {
        devices = [ ];
        config = ''
          (defsrc
            e r t y u i o p
            s d f g
            j k l scln n
            lmet rmet)

          (deflayer base
            _ _ _ _ _ _ _ _
            _ _ _ _
            _ _ _ _ _
            @sup @rsup)

          (deflayer super
            k s f o i l scln r
            d g e t
            y n u p j
            _ _)

          (defalias
            sup  (multi lmet (layer-while-held super))
            rsup (multi rmet (layer-while-held super)))
        '';
      };
    };
  };

}
