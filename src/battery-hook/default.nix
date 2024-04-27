# TODO Hibernator should be nixified and also do the same thing as
# i3wm-helper-system.

config@{ machine, username, hibernator, write-text, write-shell-app
, to-shell-var, systemd-user-units-path, bundle }:
packages@{ }:

bundle {
  name = "battery-hook";
  packages = rec {
    hook-script = write-shell-app {
      name = "battery-hook";
      text = ''
        ${to-shell-var "device" machine.battery-device}
        critical_threshold=10

        get_level() {
            local energy_now
            energy_now="$(cat "/sys/class/power_supply/$device/energy_now")"
            local energy_full
            energy_full="$(cat "/sys/class/power_supply/$device/energy_full")"
            echo $((100 * "$energy_now" / "$energy_full"))
        }

        is_critical() {
            test "$(get_level)" -le "$critical_threshold"
        }

        is_discharging() {
            local status
            status="$(cat "/sys/class/power_supply/$device/status")"
            test "$status" = "Discharging"
        }

        if is_critical && is_discharging; then
            ${hibernator}
        fi
      '';
    };
    service = write-text {
      name = "battery-hook.service";
      destination = systemd-user-units-path + "/battery-hook.service";
      text = ''
        [Unit]
        Description=Battery level hook

        [Service]
        Type=oneshot
        ExecStart=${hook-script}/bin/battery-hook
      '';
    };
    timer = write-text {
      name = "battery-hook.timer";
      destination = systemd-user-units-path + "/battery-hook.timer";
      text = ''
        [Unit]
        Description=Battery level hook timer

        [Timer]
        OnBootSec=2min
        OnUnitActiveSec=2min

        [Install]
        WantedBy=timers.target
      '';
    };
  };
}
