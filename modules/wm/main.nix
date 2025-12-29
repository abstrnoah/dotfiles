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
      cfg = config.brumal.i3wm;
      k = cfg.keys;
    in
    {

      imports = [ top.config.flake.nixosModules.brumal-wm ];

      config.services = {
        xserver.displayManager.lightdm.enable = true;
        xserver.enable = true;
        xserver.windowManager.i3 = {
          package = pkgs.i3-rounded;
          extraPackages = [
            pkgs.i3status
            pkgs.i3lock
            pkgs.rofi
          ];
        };
      };

      config.brumal.i3wm = {

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

        body.leader = k.mod;

      };

    };
}
