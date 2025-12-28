{
  flake.nixosModules.brumal =
    {
      pkgs,
      config,
      library,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        ;
      cfg = config.brumal.kitty;
      c = config.brumal.colourscheme;
    in
    {
      options.brumal.kitty.conf = mkOption {
        type = types.lines;
        default = "";
      };
      config = {
        environment.systemPackages = [ pkgs.kitty ];
        environment.variables.TERMINAL = "kitty";
        brumal.files.xdgConfig."kitty/kitty.conf".text = cfg.conf;
        brumal.kitty.conf = ''
          foreground            ${c.special.foreground}
          background            ${c.special.background}
          selection_foreground  ${c.special.selection.foreground}
          selection_background  ${c.special.selection.background}
          cursor                ${c.special.cursor}
          color0                ${c.table."0"}
          color8                ${c.table."8"}
          color1                ${c.table."1"}
          color9                ${c.table."9"}
          color2                ${c.table."2"}
          color10               ${c.table."10"}
          color3                ${c.table."3"}
          color11               ${c.table."11"}
          color4                ${c.table."4"}
          color12               ${c.table."12"}
          color5                ${c.table."5"}
          color13               ${c.table."13"}
          color6                ${c.table."6"}
          color14               ${c.table."14"}
          color7                ${c.table."7"}
          color15               ${c.table."15"}
        '';
      };
    };
}
