{
  flake.nixosModules.brumal =
    {
      library,
      config,
      utilities,
      pkgs,
      ...
    }:
    let
      inherit (library) mkOption types concatMapAttrsStringSep;
      cfg = config.brumal.rofi;
    in
    {
      options.brumal.rofi = {
        theme = mkOption { type = types.str; };
        config = mkOption { type = types.attrsOf (types.attrsOf types.str); };
      };
      config.brumal.profile.packages = [
        pkgs.rofi
      ];
      config.nixpkgs.overlays = [
        (final: prev: {
          rofi = prev.rofi.override { symlink-dmenu = true; };
        })
      ];
      config.brumal.files.xdgConfig."rofi/config.rasi".text =
        let
          makeBody = concatMapAttrsStringSep "\n" (name: value: "${name}: ${value};");
          makeSection = name: text: "${name} {\n${text}\n}";
        in
        ''
          @theme "${cfg.theme}"

          ${(concatMapAttrsStringSep "\n" (name: value: makeSection name (makeBody value)) cfg.config)}
        '';
    };
}
