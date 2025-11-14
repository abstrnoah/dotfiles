{
  flake.nixosModules.base =
    { pkgs, ... }:
    let
      trackpointDeviceName = "TPPS/2 IBM TrackPoint";
      touchpadDeviceName = "Synaptics TM3276-022";
    in
    {
      services.xserver.xkb.options = "ctrl:nocaps";
      console.useXkbConfig = true;
      # https://github.com/NixOS/nixpkgs/issues/299468
      services.xserver.displayManager.sessionCommands = ''
        ${pkgs.xorg.xinput}/bin/xinput set-prop "${touchpadDeviceName}" "libinput Disable While Typing Enabled" 1
        ${pkgs.xorg.xinput}/bin/xinput disable "${touchpadDeviceName}"
      '';
    };
}
