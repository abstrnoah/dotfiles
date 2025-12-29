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
        mapAttrs'
        genAttrs
        attrNames
        hexColourType
        ;

      cfg = config.brumal.colourscheme;

      colourNumberName = {
        "0" = "black";
        "8" = "black";
        "1" = "red";
        "9" = "red";
        "2" = "green";
        "10" = "green";
        "3" = "yellow";
        "11" = "yellow";
        "4" = "blue";
        "12" = "blue";
        "5" = "magenta";
        "13" = "magenta";
        "6" = "cyan";
        "14" = "cyan";
        "7" = "white";
        "15" = "white";
      };

      opts = {
        special.background = mkOption { type = hexColourType; };
        special.foreground = mkOption { type = hexColourType; };
        special.cursor = mkOption { type = hexColourType; };
        special.selection.background = mkOption { type = hexColourType; };
        special.selection.foreground = mkOption { type = hexColourType; };
        table = genAttrs (attrNames colourNumberName) (name: mkOption { type = hexColourType; });
      };

    in
    {
      options.brumal.colourscheme = opts;

      config.brumal.xresources = {
        "*.background" = cfg.special.background;
        "*.foreground" = cfg.special.foreground;
        "*.cursorColor" = cfg.special.cursor;
        "*.color0" = cfg.table."0";
        "*.color8" = cfg.table."8";
        "*.color1" = cfg.table."1";
        "*.color9" = cfg.table."9";
        "*.color2" = cfg.table."2";
        "*.color10" = cfg.table."10";
        "*.color3" = cfg.table."3";
        "*.color11" = cfg.table."11";
        "*.color4" = cfg.table."4";
        "*.color12" = cfg.table."12";
        "*.color5" = cfg.table."5";
        "*.color13" = cfg.table."13";
        "*.color6" = cfg.table."6";
        "*.color14" = cfg.table."14";
        "*.color7" = cfg.table."7";
        "*.color15" = cfg.table."15";
      };
    };
}
