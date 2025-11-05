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
      dims = library.mapAttrs (_: builtins.toString) cfg.dimensions;
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
          resize_sm = 2;
          resize_lg = 50;
        };

        brightness_interval = 5;

        body.directives = [
          ''border_radius 2''
          ''default_border pixel ${dims.default_border}''
          ''gaps inner ${dims.base_gap_inner}''
          # Use Mouse+$mod to drag floating windows to their wanted position
          ''floating_modifier ${k.mod}''
          ''show_marks no''
        ];

        body.leader = k.mod;

        body.bindsym = {
          # Terminal
          "${k.enter}" = "exec i3-sensible-terminal";

          # Run
          ${k.colon} = "exec rofi -show run";

          # File browser
          slash = "exec rofi -show filebrowser";

          # Change focus
          h = "focus left";
          j = "focus down";
          k = "focus up";
          l = "focus right";

          # Move focused window
          "${k.alt}+h" = "move left";
          "${k.alt}+j" = "move down";
          "${k.alt}+k" = "move up";
          "${k.alt}+l" = "move right";

          # Split with vim-like mneumonics
          v = "split h";
          s = "split v";

          # Change container layout
          t = "layout toggle tabbed stacking";
          e = "layout toggle splitv splith";

          # Kill focused window
          "${k.shift}+q" = "kill";

          # Fullscreen focused container
          f = "fullscreen toggle";

          # Floating
          "${k.shift}+space" = "floating toggle";

          # Marks
          m = "exec i3-input -F 'mark --add %s' -l 1 -P 'mark: '";
          ${k.singlequote} = "exec i3-input -F '[con_mark=\"^%s$\"] focus' -l 1 -P 'goto: '";
          "${k.shift}+m" = "unmark";

          # Go to window
          d = "exec rofi -show window";

          # Change workspace
          n = "workspace next_on_output";
          p = "workspace prev_on_output";
          comma = "workspace back_and_forth";
          "${k.alt}+r" = "exec i3-input -F 'rename workspace to \"%s\"' -P 'rename ws: '";
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
