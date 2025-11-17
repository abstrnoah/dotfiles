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
      inherit (library) mapAttrs;
      inherit (utilities) writeShellApplication;

      cfg = config.brumal.i3wm;
      k = cfg.keys;
      env = config.brumal.env;
      dims = library.mapAttrs (_: builtins.toString) cfg.dimensions;
      i3 = config.services.xserver.windowManager.i3.package;

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

        body.bindsym = {

          # Kill focused window
          "${k.shift}+q" = "kill";

          # Floating
          "${k.shift}+space" = "floating toggle";

        };

        body.modes.system = {
          key = "${k.grave}";
          block.body.bindsym = {
            e = "exec i3-nagbar -t warning -m 'Exit i3wm?' -b 'Yeah.' 'i3-msg exit'";
            s = "exec i3-nagbar -t warning -m 'Shutdown?' -b 'Yeah.' 'shutdown now'";
            "${k.shift}+s" = "exec i3-nagbar -t warning -m 'Reboot?' -b 'Yeah.' 'shutdown -r now'";
            r = "reload";
            "${k.shift}+r" = "restart";
          };
        };

        body.modes.resize = {
          key = "r";
          block.body.bindsym = {
            h = "resize shrink width ${dims.resize_sm} px or ${dims.resize_sm} ppt";
            j = "resize grow height ${dims.resize_sm} px or ${dims.resize_sm} ppt";
            k = "resize shrink height ${dims.resize_sm} px or ${dims.resize_sm} ppt";
            l = "resize grow width ${dims.resize_sm} px or ${dims.resize_sm} ppt";
          };
        };

        body.blocks.bar.body.directives = [ ''status_command i3status'' ];

      };

    };
}
