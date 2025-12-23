{
  flake.nixosModules.brumal =
    {
      library,
      config,
      utilities,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        mapAttrs
        genAttrs
        ;

      cfg = config.brumal.colourscheme;

      opts = {
        colours = genAttrs [
          "background"
          "foreground"
          "cursor"
          "black0"
          "black8"
          "red1"
          "red9"
          "green2"
          "green10"
          "yellow3"
          "yellow11"
          "blue4"
          "blue12"
          "magenta5"
          "magenta13"
          "cyan6"
          "cyan14"
          "white7"
          "white15"
        ] (name: mkOption { type = types.strMatching "[[:xdigit:]]{6}"; });
      };

    in
    {
      options.brumal.colourscheme = opts;
      config.brumal.xresources = mapAttrs (_: v: "#${v}") {
        "*.background" = cfg.colours.background;
        "*.foreground" = cfg.colours.foreground;
        "*.cursorColor" = cfg.colours.cursor;
        "*.color0" = cfg.colours.black0;
        "*.color8" = cfg.colours.black8;
        "*.color1" = cfg.colours.red1;
        "*.color9" = cfg.colours.red9;
        "*.color2" = cfg.colours.green2;
        "*.color10" = cfg.colours.green10;
        "*.color3" = cfg.colours.yellow3;
        "*.color11" = cfg.colours.yellow11;
        "*.color4" = cfg.colours.blue4;
        "*.color12" = cfg.colours.blue12;
        "*.color5" = cfg.colours.magenta5;
        "*.color13" = cfg.colours.magenta13;
        "*.color6" = cfg.colours.cyan6;
        "*.color14" = cfg.colours.cyan14;
        "*.color7" = cfg.colours.white7;
        "*.color15" = cfg.colours.white15;
      };
    };
}
