{
  flake.nixosModules.base = {pkgs, ...}: {
    brumal.colourscheme.colours = {
      foreground = "93a1a1";
      background = "002b36";
      cursor = "002b36";
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

    fonts.packages = [ pkgs.mononoki pkgs.nerd-fonts.mononoki ];
    # fonts.fontconfig.default
  };
}
