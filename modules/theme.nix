{
  flake.nixosModules.base =
    {
      pkgs,
      library,
      config,
      ...
    }:
    let
      inherit (library) mapAttrs;

      fontName = "DejaVu Sans Mono";
      fontSize = builtins.toString 11;
      fontSizeSmall = builtins.toString 10;
      fontSizeTiny = builtins.toString 9;

      c = config.brumal.colourscheme;
    in
    {

      brumal.colourscheme = {
        special.foreground = "93a1a1";
        special.background = "002b36";
        special.cursor = "93a1a1";
        table."0" = "002b36";
        table."8" = "657b83";
        table."1" = "dc322f";
        table."9" = "dc322f";
        table."2" = "859900";
        table."10" = "859900";
        table."3" = "b58900";
        table."11" = "b58900";
        table."4" = "268bd2";
        table."12" = "268bd2";
        table."5" = "6c71c4";
        table."13" = "6c71c4";
        table."6" = "2aa198";
        table."14" = "2aa198";
        table."7" = "93a1a1";
        table."15" = "93a1a1";
      };
      brumal.rofi.theme = "solarized";

      fonts.packages = [
        pkgs.nerd-fonts.mononoki
        pkgs.noto-fonts
        pkgs.cm_unicode
        pkgs.bakoma_ttf
      ];
      fonts.fontconfig.defaultFonts.monospace = [ "${fontName}" ];
      brumal.i3wm.font = "pango:${fontName} ${fontSizeTiny}";
      brumal.rofi.config.configuration.font = ''"${fontName} ${fontSize}"'';

      brumal.i3wm.dimensions = {
        default_border = 1;
        base_gap_inner = 7;
        base_gap_outer = 0;
        resize_sm = 2;
        resize_lg = 50;
      };
      brumal.i3wm.body.directives =
        let
          dims = library.mapAttrs (_: builtins.toString) config.brumal.i3wm.dimensions;
        in
        [
          ''border_radius 2''
          ''default_border pixel ${dims.default_border}''
          ''gaps inner ${dims.base_gap_inner}''
        ];

      brumal.dunst.config.global.frame_color = ''"#${c.table."2"}"'';
      brumal.dunst.config.global.background = ''"#${c.special.background}"'';
      brumal.dunst.config.global.foreground = ''"#${c.special.foreground}"'';
      brumal.dunst.config.global.font = "${fontName} ${fontSizeSmall}";
      brumal.dunst.config.global.corner_radius = 3;

    };

}
