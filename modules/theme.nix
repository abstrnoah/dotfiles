{
  flake.nixosModules.base =
    { pkgs, ... }:
    let
      pangoFont = "Mononoki Nerd Font Mono Regular";
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

      brumal.rofi = {
        theme = "solarized";
        config.configuration.font = ''"${pangoFont} 10"'';
      };

      fonts.packages = [
        pkgs.nerd-fonts.mononoki
      ];
      fonts.fontconfig.defaultFonts.monospace = [ "Mononoki Nerd Font Mono:style=Regular" ];
      brumal.i3wm.font = "pango:${pangoFont} 9";
      brumal.xresources."URxvt.font" = "xft:Mononoki Nerd Font Mono:style=Regular:size=10";
      brumal.xresources."URxvt.boldFont" = "xft:Mononoki Nerd Font Mono:style=Bold:size=10";
      brumal.xresources."URxvt.italicFont" = "xft:Mononoki Nerd Font Mono:style=Italic:size=10";
      brumal.xresources."URxvt.boldItalicFont" =
        "xft:Mononoki Nerd Font Mono:style=Bold Italic:size=10";
    };
}
