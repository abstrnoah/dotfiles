{
  flake.nixosModules.gui =
    { pkgs, ... }:
    {
      systemd.user.services.rsibreak = {
        description = "Try to prevent RSI";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        script = "${pkgs.rsibreak}/bin/rsibreak";
      };
    };
}
