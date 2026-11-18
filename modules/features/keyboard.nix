{ self, inputs, ... }: {

  # XKB ring includes Colemak and Russian layouts;
  # QWERTY is invoked via holding Super, Ctrl or Alt so shortcuts keep QWERTY positions (Kanata).
  # Shift alone can't do this (it's needed for Colemak capitals), but Ctrl/Alt/Super+Shift work
  # since the layer is held by Ctrl/Alt/Super. Right Ctrl is Compose, so it's left out.
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
            lmet rmet lctl lalt ralt)

          (deflayer base
            _ _ _ _ _ _ _ _
            _ _ _ _
            _ _ _ _ _
            @sup @rsup @ctl @alt @ralt)

          (deflayer qwerty
            k s f o i l scln r
            d g e t
            y n u p j
            _ _ _ _ _)

          (defalias
            sup  (multi lmet (layer-while-held qwerty))
            rsup (multi rmet (layer-while-held qwerty))
            ctl  (multi lctl (layer-while-held qwerty))
            alt  (multi lalt (layer-while-held qwerty))
            ralt (multi ralt (layer-while-held qwerty)))
        '';
      };
    };
  };

}
