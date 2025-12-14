{
  flake.nixosModules.gui =
    {
      pkgs,
      library,
      ...
    }:
    let
      inherit (library) readFile;
    in
    {
      # TODO make syncthing config declarative
      systemd.user.units."syncthing.service" = {
        text = readFile "${pkgs.syncthing}/share/systemd/user/syncthing.service";
        # Turns out systemd ignores [Install] section; we must enable directly.
        wantedBy = [ "default.target" ];
      };
    };
}
