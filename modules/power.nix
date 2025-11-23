{
  flake.nixosModules.gui =
    { config, ... }:
    let
      cfg = config.brumal.i3wm;
      k = cfg.keys;
      sleep-operation = "suspend-then-hibernate";
    in
    {
      programs.xss-lock.enable = true;
      services.logind.settings.Login.HandleLidSwitch = sleep-operation;
      services.logind.settings.Login.HandlePowerKey = sleep-operation;
      services.logind.settings.Login.HandleSuspendKey = sleep-operation;
      services.logind.settings.Login.IdleAction = sleep-operation;
      systemd.sleep.extraConfig = ''HibernateDelaySec=30min'';
      # TODO Doesn't seem to work.
      services.logind.settings.Login.IdleActionSec = "5min";

      systemd.services.no-wakeup-on-lid = {
        # TODO This is a toggle so we should really verify first that it's enabled.
        script = ''echo LID > /proc/acpi/wakeup'';
        wantedBy = [ "multi-user.target" ];
      };

      # Unneeded because HandlePowerKey
      # brumal.i3wm.body.bindsym.${k.tilde} = "exec systemctl suspend-then-hibernate";
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
