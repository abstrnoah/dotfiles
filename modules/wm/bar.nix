{
  flake.nixosModules.gui =
    { config, ... }:
    {
      brumal.i3status = {

        order = [
          "read_file null"
          "disk /"
          "path_exists vpn"
          "ipv6"
          "wireless _first_"
          "ethernet _first_"
          "battery all"
          "battery 0"
          "battery 1"
          "memory"
          "load"
          "cpu_usage"
          "cpu_temperature 0"
          "volume master"
          "tztime local"
          "tztime utc"
          "read_file null"
        ];

        blocks = {

          general."" = {
            colors = "true";
            output_format = "i3bar";
            interval = "5";
          };

          read_file.null = {
            path = "/dev/null";
            format = " ";
          };

          ipv6."" = {
            format_up = "%iface 󰩟 %ip";
            format_down = "";
          };

          wireless._first_ = {
            format_up = " %quality %essid %ip";
            format_down = "󰖪 ";
          };

          ethernet._first_ = {
            # if you use %speed, i3status requires root privileges
            format_up = "󰈁 %ip %speed";
            format_down = "󰈂";
          };

          path_exists.vpn = {
            path = "/proc/sys/net/ipv4/conf/wg0-mullvad";
            format = "󰿂";
            format_down = "󰌊";
          };

          battery.all = {
            format = "%status %percentage (%remaining)";
            format_down = "󱉝";
            format_percentage = "%.00f%s";
            last_full_capacity = "true";
            status_bat = "🔋";
            status_unk = "󰂑";
            status_chr = "⚡";
            status_idle = "󱟣";
            status_full = "󱟢";
          };

          battery."0" = {
            format = "%status₀ %percentage";
            format_down = "󱉝₀";
            format_percentage = "%.00f%s";
            last_full_capacity = "true";
            status_bat = "🔋";
            status_unk = "󰂑";
            status_chr = "⚡";
            status_idle = "󱟣";
            status_full = "󱟢";
          };

          battery."1" = {
            format = "%status₁ %percentage";
            format_down = "󱉝₁";
            format_percentage = "%.00f%s";
            last_full_capacity = "true";
            status_bat = "🔋";
            status_unk = "󰂑";
            status_chr = "⚡";
            status_idle = "󱟣";
            status_full = "󱟢";
          };

          run_watch.DHCP = {
            pidfile = "/var/run/dhclient*.pid";
          };

          run_watch.VPN = {
            pidfile = "/var/run/vpnc/pid";
          };

          load."" = {
            format = "󱕱 %1min";
          };

          disk."/" = {
            format = " %avail";
          };

          cpu_usage."" = {
            format = " %usage";
          };

          cpu_temperature."0" = {
            max_threshold = "50";
            format = " %degrees°C";
          };

          memory."" = {
            format = " %percentage_used";
            decimals = "0";
          };

          volume.master = {
            format = "󰕾  %volume ";
            format_muted = "󰝟 (%volume)";
          };

        };

      };
    };
}
