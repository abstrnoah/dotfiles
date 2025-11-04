{
  flake.nixosModules.gui =
    { ownerName, pkgs, ... }:
    {
      services.xserver.windowManager.i3.extraPackages = [ pkgs.light ];
      programs.light = {
        enable = true;
        brightnessKeys.enable = true;
      };
      users.users.${ownerName}.extraGroups = [ "video" ];
    };
}
