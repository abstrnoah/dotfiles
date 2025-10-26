top@{ config, ... }:
{
  flake.nixosModules.gui =
    {
      config,
      library,
      utilities,
      pkgs,
      ...
    }:
    let
      cfg = config.brumal.programs.i3wm;
      k = cfg.keys;
      env = config.brumal.env;
    in
    {

      imports = [ top.config.flake.nixosModules.brumal-wm ];

      config.services = {
        xserver.windowManager.i3 = {
          package = pkgs.i3-rounded;
          extraPackages = [
            pkgs.i3status
            pkgs.i3lock
            pkgs.rofi
          ];
        };
      };

      config.brumal.programs.i3wm = {

        keys = rec {
          escringe = "Escape";
          esc = "ctrl+bracketleft";
          ctrl = "ctrl";
          alt = "Mod1";
          super = "Mod4";
          shift = "shift";
          enter = "Return";
          colon = "shift+semicolon";
          percent = "shift+5";
          pipe = "shift+backslash";
          minus = "minus";
          plus = "equal";
          underscore = "shift+minus";
          grave = "grave";
          tilde = "shift+grave";
          singlequote = "apostrophe";
          mod = super;
        };

        font = "pango:mononoki regular 7";

        dimensions = {
          default_border = 1;
          base_gap_inner = 7;
          base_gap_outer = 0;
        };

        brightness_interval = 5;

        body.directives = [
          ''border_radius 2''
          ''default_border pixel ${builtins.toString cfg.dimensions.default_border}''
          ''gaps inner ${builtins.toString cfg.dimensions.base_gap_inner}''
        ];

        body.bindsym = {
          "${k.mod}+${k.enter}" = "exec i3-sensible-terminal";
        };

        body.modes.system = {
          key = "${k.mod}+${k.grave}";
          block.body.bindsym = {
            e = "exec i3-nagbar -t warning -m 'Exit i3wm?' -b 'Yeah.' 'i3-msg exit'";
            s = "exec i3-nagbar -t warning -m 'Shutdown?' -b 'Yeah.' 'shutdown now'";
            "${k.shift}+s" = "exec i3-nagbar -t warning -m 'Reboot?' -b 'Yeah.' 'shutdown -r now'";
            r = "reload";
            "${k.shift}+r" = "restart";
          };
        };

        body.blocks.bar.body.directives = [ ''status_command i3status'' ];

      };

    };
}
