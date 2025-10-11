{
  flake.modules.nixos.wm =
    {
      config,
      packages,
      library,
      utilities,
      ...
    }:
    let
      inherit (library)
        concatStringsSep
        mapAttrsToList
        collect
        isString
        mapAttrs
        mkOption
        types
        ;
      inherit (utilities) writeTextFile;
      cfg = config.brumal.cfg.i3status;
      rc = config.brumal.rcs.i3status;
      rcDestination = "${config.brumal.env.XDG_CONFIG_HOME}/i3status/config";
      rcFile = rc + rcDestination;
    in
    {

      options.brumal.cfg.i3status = {
        order = mkOption { type = types.listOf types.str; };
        blocks = mkOption { type = types.attrsOf (types.attrsOf (types.attrsOf types.str)); };
      };

      config.brumal.cfg.i3wm.body.blocks.bar.body.directives = [
        "status_command ${packages.i3status} --config ${rcFile}"
      ];

      config.brumal.rcs.i3status = writeTextFile {
        name = "i3status-rc";
        destination = rcDestination;
        text =
          let
            orderText = concatStringsSep "\n" (map (x: ''order += "${x}"'') cfg.order);
            mkDirectiveText = key: value: "    ${key} = ${value}";
            mkBlockText = (
              kind: name: values: ''
                ${kind} ${name} {
                ${concatStringsSep "\n" (mapAttrsToList mkDirectiveText values)}
                }
              ''
            );
            blocksText = concatStringsSep "\n" (
              collect isString (mapAttrs (kind: (mapAttrs (mkBlockText kind))) cfg.blocks)
            );
          in
          ''
            ${orderText}

            ${blocksText}
          '';
      };

      config.brumal.cfg.i3status = {

        order = [
          "read_file timer"
          "disk /"
          "wireless _first_"
          "ethernet _first_"
          "battery 0"
          "load"
          "cpu_usage"
          "cpu_temperature 0"
          "cpu_temperature 1"
          "volume master"
          "read_file weather"
          "tztime local"
          "tztime utc"
        ];

        blocks = {

          general."" = {
            colors = "true";
            output_format = "i3bar";
            interval = "5";
          };

          cpu_usage."" = {
            format = "%usage";
          };

          wireless._first_ = {
            format_up = "🌐📡%quality %essid %ip";
            format_down = "🌐📡❌";
          };

          ethernet._first_ = {
            # if you use %speed, i3status requires root privileges
            format_up = "🌐🔌 %ip %speed";
            format_down = "🌐🔌❌";
          };

          battery."0" = {
            format = "%status%percentage (%remaining %consumption)";
            format_percentage = "%.01f%s";
            last_full_capacity = "true";
            status_bat = "🔋";
            status_unk = "❓";
            status_chr = "⚡";
            status_full = "😎";
          };

          run_watch.DHCP = {
            pidfile = "/var/run/dhclient*.pid";
          };

          run_watch.VPN = {
            pidfile = "/var/run/vpnc/pid";
          };

          load."" = {
            format = "%1min";
          };

          disk."/" = {
            format = "%avail";
          };

          cpu_temperature."0" = {
            max_threshold = "50";
            format = "%degrees°C";
          };

          cpu_temperature."1" = {
            max_threshold = "50";
            format = "%degrees°C";
          };

          volume.master = {
            format = "🕪  %volume ";
            format_muted = "🕨 (%volume)";
            device = "pulse";
          };

          read_file.weather = {
            path = "/tmp/latest-wttrin";
            format_bad = "🌎❓";
          };
        };

      };

    };
}
