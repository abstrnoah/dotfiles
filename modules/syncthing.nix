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
      # FIXME failing to start at boot due to reported port conflict
      # TODO make syncthing config declarative
      systemd.user.units."syncthing.service" = {
        text = readFile "${pkgs.syncthing}/share/systemd/user/syncthing.service";
        # Turns out systemd ignores [Install] section; we must enable directly.
        wantedBy = [ "default.target" ];
      };
    };
}
