{
  flake.modules.brumal.bluetooth =
    { library, ... }:
    {
      # TODO impure
      legacyDotfiles.bluetoothctl-by-alias = library.storeLegacyDotfiles "bluetooth";
    };
}
