# This is just for defining i3 config. See `wm.nix` for declarations and setup.
{
  flake.modules.nixos.wm =
    ctx@{ packages, config, ... }:
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

        body =
          { config, ... }:
          {

            directives = [

              "font pango:mononoki regular 7"

            ];

          };

      };
    };
}
