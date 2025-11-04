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
      inherit (utilities) writeTextFile;
      opts = {
        theme = mkOption { type = types.str; };
        config = mkOption { type = types.attrsOf (types.attrsOf types.str); };
      };
      cfg = config.brumal.programs.rofi;
      env = config.brumal.env;
      rc = writeTextFile {
        name = "config.rasi";
        destination = "${env.XDG_CONFIG_HOME}/rofi/config.rasi";
        text =
          let
            makeBody = concatMapAttrsStringSep "\n" (name: value: "${name}: ${value};");
            makeSection = name: text: "${name} {\n${text}\n}";
          in
          ''
            ${(concatMapAttrsStringSep "\n" (name: value: makeSection name (makeBody value)) cfg.config)}

            @theme "${cfg.theme}"
          '';
      };
    in
    {
      options.brumal.programs.rofi = opts;
      config.brumal.profile.packages = [
        pkgs.rofi
        rc
      ];
      config.nixpkgs.overlays = [
        (final: prev: {
          rofi = prev.rofi.override { symlink-dmenu = true; };
        })
      ];
    };
}
