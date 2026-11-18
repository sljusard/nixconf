{ self, inputs, ... }: {

  flake.nixosModules.myYazi = { pkgs, lib, config, ... }: let
    colemak = [
      "q" "w" "f" "p" "g" "j" "l" "u" "y" ";" "[" "]"
      "a" "r" "s" "t" "d" "h" "n" "e" "i" "o" "'"
      "z" "x" "c" "v" "b" "k" "m" "," "." "`"
      "Q" "W" "F" "P" "G" "J" "L" "U" "Y" ":" "{" "}"
      "A" "R" "S" "T" "D" "H" "N" "E" "I" "O" "\""
      "Z" "X" "C" "V" "B" "K" "M" "<" ">" "~"
    ];
    russian = [
      "й" "ц" "у" "к" "е" "н" "г" "ш" "щ" "з" "х" "ъ"
      "ф" "ы" "в" "а" "п" "р" "о" "л" "д" "ж" "э"
      "я" "ч" "с" "м" "и" "т" "ь" "б" "ю" "ё"
      "Й" "Ц" "У" "К" "Е" "Н" "Г" "Ш" "Щ" "З" "Х" "Ъ"
      "Ф" "Ы" "В" "А" "П" "Р" "О" "Л" "Д" "Ж" "Э"
      "Я" "Ч" "С" "М" "И" "Т" "Ь" "Б" "Ю" "Ё"
    ];
    toRu = builtins.listToAttrs (lib.zipListsWith lib.nameValuePair colemak russian);
    tr = k: toRu.${k} or k;

    defaults = builtins.fromTOML (builtins.readFile
      "${pkgs.yazi-unwrapped.srcs.code_src}/yazi-config/preset/keymap-default.toml");

    # Only keys that translate to Cyrillic are mirrored, so nothing collides with Latin binds
    mirror = binds: lib.concatMap (b:
      let on = lib.toList b.on; ru = map tr on;
      in lib.optional (ru != on) (b // { on = ru; })) binds;
  in {
    config = {
      settings.keymap = lib.genAttrs [ "mgr" "tasks" "spot" "pick" "confirm" "help" ]
        (mode: { prepend_keymap = mirror defaults.${mode}.keymap; });
    };
  };

  perSystem = { pkgs, ... }: {
    packages.myYazi = inputs.wrapper-modules.wrappers.yazi.wrap {
      inherit pkgs;
      imports = [self.nixosModules.myYazi];
    };
  };

}
