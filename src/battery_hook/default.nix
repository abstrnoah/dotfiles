{ nixpkgs, battery_device, username, hibernate_command }:
let
  write_text = name: text: "${nixpkgs.writeTextDir name text}/${name}";
  hook_script = nixpkgs.writeShellApplication {
    name = "battery-hook";
    text = ''
      device="${battery_device}"
      critical_threshold=10

      get_level() {
          local energy_now
          energy_now="$(cat /sys/class/power_supply/$device/energy_now)"
          local energy_full
          energy_full="$(cat /sys/class/power_supply/$device/energy_full)"
          echo $((100 * "$energy_now" / "$energy_full"))
      }

      is_critical() {
          test "$(get_level)" -le "$critical_threshold"
      }

      is_discharging() {
          local status
          status="$(cat /sys/class/power_supply/$device/status)"
          test "$status" = "Discharging"
      }

      if is_critical && is_discharging; then
          ${hibernate_command}
      fi
    '';
  };
in {
  service = write_text "battery-hook.service" ''
    [Unit]
    Description=Battery level hook

    [Service]
    Type=oneshot
    ExecStart=${hook_script}/bin/battery-hook
    User=root
    Group=root
  '';
  timer = write_text "battery-hook.timer" ''
    [Unit]
    Description=Battery level hook timer

    [Timer]
    OnBootSec=2min
    OnUnitActiveSec=2min

    [Install]
    WantedBy=timers.target
  '';
}
