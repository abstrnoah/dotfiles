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

      c = config.brumal.colourscheme.colours;
    in
    {

      brumal.colourscheme.colours = {
        foreground = "93a1a1";
        background = "002b36";
        cursor = "93a1a1";
        black0 = "002b36";
        black8 = "657b83";
        red1 = "dc322f";
        red9 = "dc322f";
        green2 = "859900";
        green10 = "859900";
        yellow3 = "b58900";
        yellow11 = "b58900";
        blue4 = "268bd2";
        blue12 = "268bd2";
        magenta5 = "6c71c4";
        magenta13 = "6c71c4";
        cyan6 = "2aa198";
        cyan14 = "2aa198";
        white7 = "93a1a1";
        white15 = "93a1a1";
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
      brumal.xresources."URxvt.font" = "xft:${fontName}:size=${fontSize}";
      brumal.xresources."URxvt.boldFont" = "xft:${fontName}:style=Bold:size=${fontSize}";
      brumal.xresources."URxvt.italicFont" = "xft:${fontName}:style=Italic:size=${fontSize}";
      brumal.xresources."URxvt.boldItalicFont" = "xft:${fontName}:style=Bold Italic:size=${fontSize}";
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

      brumal.dunst.config.global.frame_color = ''"#${c.green2}"'';
      brumal.dunst.config.global.background = ''"#${c.background}"'';
      brumal.dunst.config.global.foreground = ''"#${c.foreground}"'';
      brumal.dunst.config.global.font = "${fontName} ${fontSizeSmall}";
      brumal.dunst.config.global.corner_radius = 3;

    };

}
