{
  flake.nixosModules.gui =
    { pkgs, config, ... }:
    let
      l = config.brumal.local.variables;
    in
    {
      systemd.user.services.redshift = {
        description = "Redshift colour temperature adjuster";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        script = ''
          ${pkgs.redshift}/bin/redshift \
            -l ${l.LATITUDE.shellValue}:${l.LONGITUDE.shellValue} \
        '';
        serviceConfig = {
          RestartSec = 3;
          Restart = "always";
        };
      };
    };
}
