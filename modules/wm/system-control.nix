{
  flake.nixosModules.gui =
    { config, ... }:
    let
      cfg = config.brumal.i3wm;
      k = cfg.keys;
    in
    {
      brumal.i3wm.body.modes.system = {
        key = "${k.grave}";
        block.body.bindsym = {
          e = "exec i3-nagbar -t warning -m 'Exit i3wm?' -b 'Yeah.' 'i3-msg exit'";
          s = "exec i3-nagbar -t warning -m 'Shutdown?' -b 'Yeah.' 'shutdown now'";
          "${k.shift}+s" = "exec i3-nagbar -t warning -m 'Reboot?' -b 'Yeah.' 'shutdown -r now'";
          r = "reload";
          "${k.shift}+r" = "restart";
        };
      };
    };
}
