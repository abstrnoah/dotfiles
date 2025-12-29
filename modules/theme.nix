{ moduleWithSystem, ... }:
{
  flake.nixosModules.base = moduleWithSystem (
    perSystem@{ inputs' }:
    {
      pkgs,
      library,
      config,
      ...
    }:
    let
      inherit (library) mapAttrs;

      # TODO Do it better
      wallpaper = inputs'.wallpapers.packages.pixel-city-at-night-png;

      fontName = "DejaVu Sans Mono";
      fontSize = builtins.toString 11;
      fontSizeSmall = builtins.toString 10;
      fontSizeTiny = builtins.toString 9;

      c = config.brumal.colourscheme;
    in
    {
      brumal.i3wm.body.exec_always = [
        "--no-startup-id ${pkgs.feh}/bin/feh --bg-fill ${wallpaper}"
      ];

      brumal.colourscheme = {
        # From Kitty's "Solarized Dark - Patched" theme
        special.background = "#001e26";
        special.foreground = "#708183";
        special.selection.background = "#002731";
        special.selection.foreground = "#001e26";
        special.cursor = c.table."12";
        table."0" = "#002731";
        table."8" = "#465a61";
        table."1" = "#d01b24";
        table."9" = "#bd3612";
        table."2" = "#728905";
        table."10" = "#465a61";
        table."3" = "#a57705";
        table."11" = "#52676f";
        table."4" = "#2075c7";
        table."12" = "#708183";
        table."5" = "#c61b6e";
        table."13" = "#5856b9";
        table."6" = "#259185";
        table."14" = "#81908f";
        table."7" = "#e9e2cb";
        table."15" = "#fcf4dc";
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
          ''border_radius 8''
          ''default_border pixel ${dims.default_border}''
          ''gaps inner ${dims.base_gap_inner}''
          #class titlebarborder bg text indicator child_border
          "client.focused           ${c.black}  ${c.black}  ${c.bright-white}  ${c.green}  ${c.bright-yellow}"
          "client.focused_inactive  ${c.black}  ${c.black}  ${c.bright-green}  ${c.green}  ${c.black}"
          "client.unfocused         ${c.black}  ${c.black}  ${c.bright-green}  ${c.green}  ${c.black}"
        ];
      brumal.i3wm.body.blocks.bar.body.blocks.colors.body.directives = [
        "background ${c.black}"
        "statusline ${c.bright-blue}"
        "separator  ${c.bright-black}"
        #class border bg text
        "focused_workspace  ${c.bright-cyan}    ${c.black}  ${c.bright-white}"
        "active_workspace   ${c.bright-black}   ${c.black}  ${c.white}"
        "inactive_workspace ${c.bright-black}   ${c.black}  ${c.bright-blue}"
        "urgent_workspace   ${c.bright-red}     ${c.black}  ${c.bright-red}"
        "binding_mode       ${c.green}          ${c.black}  ${c.yellow}"
      ];
      brumal.i3status.blocks.general."" = {
        color_good = "${c.green}";
        color_degraded = "${c.yellow}";
        color_bad = "${c.red}";
      };

      brumal.dunst.config.global.frame_color = ''"${c.green}"'';
      brumal.dunst.config.global.background = ''"${c.special.background}"'';
      brumal.dunst.config.global.foreground = ''"${c.special.foreground}"'';
      brumal.dunst.config.global.font = "${fontName} ${fontSizeSmall}";
      brumal.dunst.config.global.corner_radius = 3;

    }
  );

}
