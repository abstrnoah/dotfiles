# This is just for defining i3 config.
# See `wm.nix` for declarations and setup.
# Also note that i3 directives are defined across different modules.
{
  flake.modules.nixos.wm =
    { packages, config, ... }:
    let
      cfg = config.brumal.cfg.i3wm;
    in
    {
      brumal.cfg.i3wm = {

        keys = {
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
          mod = config.keys.super;
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
          ];
        };

      };
    };
}
