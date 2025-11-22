{
  flake.nixosModules.gui =
    { config, ... }:
    let
      cfg = config.brumal.i3wm;
      k = cfg.keys;
    in
    {
      services.logind.settings.Login.IdleAction = "suspend-then-hibernate";
      # TODO Doesn't seem to work.
      services.logind.settings.Login.IdleActionSec = "1min";
      programs.xss-lock.enable = true;

      brumal.i3wm.body.bindsym.${k.tilde} = "exec systemctl suspend-then-hibernate";
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
