{
  flake.nixosModules.gui =
    { ownerName, pkgs, ... }:
    let
      step = toString 10;
      xbacklight = "${pkgs.xbacklight}/bin/xbacklight";
    in
    {
      hardware.acpilight.enable = true;
      # brightnessKeys.enable = true;
      users.users.${ownerName}.extraGroups = [ "video" ];
      services.actkbd = {
        enable = true;
        bindings = [
          {
            keys = [ 224 ];
            events = [ "key" ];
            command = "${xbacklight} -dec ${step}";
          }
          {
            keys = [ 225 ];
            events = [ "key" ];
            command = "${xbacklight} -inc ${step}";
          }
        ];
      };
    };
}
