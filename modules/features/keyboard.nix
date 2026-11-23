{ self, inputs, ... }: {

  flake.nixosModules.keyboard = { ... }: {
    services.xserver.xkb = {
      layout = "us,ru";
      variant = "colemak,";
      options = "grp:alt_shift_toggle,grp:caps_select,compose:rctrl";
    };

    services.kanata = {
      enable = true;
      keyboards.main = {
        devices = [ ];
        config = ''
          (defsrc
            caps
            e r t y u i o p
            s d f g
            j k l scln n
            lsft rsft
            lmet rmet lctl lalt ralt)

          ;; Normal mode: Colemak/RU ring via XKB, QWERTY only while a mod is held
          (deflayer base
            @toqw
            _ _ _ _ _ _ _ _
            _ _ _ _
            _ _ _ _ _
            _ _
            @sup @rsup @ctl @alt @ralt)

          ;; Held layer for shortcuts
          (deflayer qwerty
            @toqw
            k s f o i l scln r
            d g e t
            y n u p j
            _ _
            _ _ _ _ _)

          ;; Full QWERTY mode (base layer after CapsLock)
          (deflayer qwmode
            @toba
            k s f o i l scln r
            d g e t
            y n u p j
            @qsft @qrsft
            _ _ _ @qalt @qralt)

          ;; Alt held in QWERTY mode: Shift swallowed so XKB doesn't toggle
          (deflayer qwalt
            @toba
            k s f o i l scln r
            d g e t
            y n u p j
            XX XX
            _ _ _ _ _)

          ;; Shift held in QWERTY mode: Alt swallowed; Shift+Caps blocked
          (deflayer qwsft
            XX
            k s f o i l scln r
            d g e t
            y n u p j
            _ _
            _ _ _ XX XX)

          (defalias
            sup   (multi lmet (layer-while-held qwerty))
            rsup  (multi rmet (layer-while-held qwerty))
            ctl   (multi lctl (layer-while-held qwerty))
            alt   (multi lalt (layer-while-held qwerty))
            ralt  (multi ralt (layer-while-held qwerty))
            toqw  (multi caps (layer-switch qwmode))
            toba  (multi caps (layer-switch base))
            qalt  (multi lalt (layer-while-held qwalt))
            qralt (multi ralt (layer-while-held qwalt))
            qsft  (multi lsft (layer-while-held qwsft))
            qrsft (multi rsft (layer-while-held qwsft)))
        '';
      };
    };
  };

}
