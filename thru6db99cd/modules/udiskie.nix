{
  flake.modules.nixos.wm =
    {
      config,
      utilities,
      packages,
      pkgs,
      ...
    }:
    let
      udiskieRcPath = "${config.brumal.env.XDG_CONFIG_HOME}/udiskie/config.yml";
    in
    {
      brumal.packages.udiskie = utilities.writeShellApplication {
        name = "udiskie";
        runtimeInputs = [ pkgs.udiskie ];
        text = "udiskie --config=${udiskieRcPath}";
      };
      brumal.cfg.i3wm.body.directives = [ "exec_always ${packages.udiskie}" ];
      brumal.rcs.udiskie =
        let
          udiskie-event-handler = utilities.writeShellScript "udiskie-event-handler" ''
            test "$#" -eq 2 || exit 1
            event="$1:$2"
            open_orange() {
                # TODO
                gnome-terminal --wait -- ~/store/orange/open
            }
            handle_with() {
                notify-send "udiskie $event" "running [$*]"
                "$@" || notify-send "udiskie $event" "handler failed: [$*]"
            }
            case "$event" in
                device_mounted:C8FE-2EF0) handle_with open_orange ;;
            esac
          '';
        in
        utilities.writeTextFile {
          name = "udiskie-rc";
          destination = udiskieRcPath;
          text = ''
            program_options:
              automount: false
              notify_command: "${udiskie-event-handler} '{event}' '{id_uuid}'"
            device_config:
              - id_uuid: C8FE-2EF0
                automount: true
          '';
        };
    };
}
