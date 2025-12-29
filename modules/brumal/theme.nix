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
      inherit (library)
        mkOption
        types
        mapAttrs
        mapAttrs'
        genAttrs
        getAttr
        attrNames
        attrValues
        nameValuePair
        hexColourType
        ;

      c = config.brumal.colourscheme;
      w = config.brumal.wallpaper;

      colourNumberName = {
        "0" = "black";
        "1" = "red";
        "2" = "green";
        "3" = "yellow";
        "4" = "blue";
        "5" = "magenta";
        "6" = "cyan";
        "7" = "white";
        "8" = "bright-black";
        "9" = "bright-red";
        "10" = "bright-green";
        "11" = "bright-yellow";
        "12" = "bright-blue";
        "13" = "bright-magenta";
        "14" = "bright-cyan";
        "15" = "bright-white";
      };

    in
    {
      options.brumal.colourscheme = {
        special.background = mkOption { type = hexColourType; };
        special.foreground = mkOption { type = hexColourType; };
        special.cursor = mkOption { type = hexColourType; };
        special.selection.background = mkOption { type = hexColourType; };
        special.selection.foreground = mkOption { type = hexColourType; };
        table = genAttrs (attrNames colourNumberName) (name: mkOption { type = hexColourType; });
      }
      // genAttrs (attrValues colourNumberName) (name: mkOption { type = hexColourType; });

      config.brumal.xresources = {
        "*.background" = c.special.background;
        "*.foreground" = c.special.foreground;
        "*.cursorColor" = c.special.cursor;
        "*.color0" = c.table."0";
        "*.color8" = c.table."8";
        "*.color1" = c.table."1";
        "*.color9" = c.table."9";
        "*.color2" = c.table."2";
        "*.color10" = c.table."10";
        "*.color3" = c.table."3";
        "*.color11" = c.table."11";
        "*.color4" = c.table."4";
        "*.color12" = c.table."12";
        "*.color5" = c.table."5";
        "*.color13" = c.table."13";
        "*.color6" = c.table."6";
        "*.color14" = c.table."14";
        "*.color7" = c.table."7";
        "*.color15" = c.table."15";
      };

      config.brumal.colourscheme = mapAttrs' (
        number: value: nameValuePair (getAttr number colourNumberName) value
      ) c.table;

      options.brumal.wallpaper = {
        home = mkOption { type = types.path; };
        lock = mkOption { type = types.path; };
      };

      config.brumal.i3wm.body.exec_always = [
        "--no-startup-id ${pkgs.feh}/bin/feh --bg-fill ${w.home}"
      ];

      config.services.xserver.displayManager.lightdm.background = w.lock;

    };
}
