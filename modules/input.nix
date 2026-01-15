{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      services.xserver.xkb.options = "ctrl:nocaps";
      console.useXkbConfig = true;
    };
  flake.machineModules.porcupine =
    { pkgs, ... }:
    let
      trackpointDeviceName = "TPPS/2 IBM TrackPoint";
      touchpadDeviceName = "Synaptics TM3276-022";
      wacomDeviceName = "Wacom One by Wacom S Pen Pen (0)";
    in
    {
      # https://github.com/NixOS/nixpkgs/issues/299468
      services.xserver.displayManager.sessionCommands = ''
        ${pkgs.xorg.xinput}/bin/xinput set-prop "${touchpadDeviceName}" "libinput Disable While Typing Enabled" 1
      '';
      # TODO Automatically map tablet to primary output
      services.xserver.wacom.enable = true;
    };
}
