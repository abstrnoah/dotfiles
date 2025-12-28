{
  flake.nixosModules.gui =
    { config, pkgs, ... }:
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
        script = ''
          if ${pkgs.silver-searcher}/bin/ag -c 'LID.*\*enabled' </proc/acpi/wakeup >/dev/null; then
            echo LID > /proc/acpi/wakeup
          fi
        '';
        wantedBy = [ "multi-user.target" ];
      };

      services.tlp.enable = true;

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

  flake.machineModules.porcupine = {
    services.tlp.settings = {
      # Internal battery
      START_CHARGE_THRESH_BAT0 = 60;
      STOP_CHARGE_THRESH_BAT0 = 70;
      # Removable battery
      START_CHARGE_THRESH_BAT1 = 70;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };
}
