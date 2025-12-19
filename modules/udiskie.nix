{
  flake.nixosModules.gui =
    {
      config,
      pkgs,
      utilities,
      ...
    }:
    let
      inherit (utilities)
        writeShellApplication
        ;
      handler = writeShellApplication {
        name = "udiskie-event-handler";
        runtimeInputs = [
          pkgs.libnotify
        ];
        text = ''
          test "$#" -eq 2 || exit 1
          event="$1:$2"
          open_orange() {
              ~/store/orange/open
          }
          handle_with() {
              notify-send "udiskie $event" "running [$*]"
              "$@" || notify-send "udiskie $event" "handler failed: [$*]"
          }
          case "$event" in
              device_mounted:C8FE-2EF0) handle_with open_orange ;;
          esac
        '';
      };
    in
    {
      brumal.i3wm.body.directives = [ ''exec ${pkgs.udiskie}/bin/udiskie'' ];
      brumal.udiskie.config = {
        program_options = {
          automount = false;
          notify_command = "${handler}/bin/udiskie-event-handler '{event}' '{id_uuid}'";
        };
        device_config = [
          {
            id_uuid = "C8FE-2EF0";
            automount = true;
          }
        ];
      };
    };
}
