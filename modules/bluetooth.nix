{
  flake.nixosModules.base = {
    hardware.bluetooth.enable = true;
    brumal.files.bin.bluetoothctl-by-alias.text = ''
      get_mac() {
          bluetoothctl devices \
          | awk -F ' ' -v name="$1" 'substr($0, 26) == name { print $2 }' \
          | head -n 1
      }

      # Disallow interactive mode.
      test "$#" -gt 0 || exit 1

      command="$1"

      case "$command" in
          info|pair|cancel-pairing|trust|untrust|block|unblock|remove|connect|disconnect)
              alias="$2"
              bluetoothctl "$command" "$(get_mac "$alias")"
              ;;
          *)
              bluetoothctl "$@"
              ;;
      esac
    '';

  };
}
