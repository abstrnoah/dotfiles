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
        dimensions = {
          default_border = 1;
          base_gap_inner = 7;
          base_gap_outer = 0;
        };
        brightness_interval = 5;

        body = {
          directives = [
            ''for_window [class=".*"] border pixel ${builtins.toString cfg.dimensions.default_border}''
            ''gaps inner ${builtins.toString cfg.dimensions.base_gap_inner}''
            ''border_radius 2''

            ''bindsym ${k.mod}+${k.enter} i3-sensible-terminal''
          ];
        };

      };

    };
}
