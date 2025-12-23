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
        # DO NOT set wantedBy = [ "default.target" ]; because that cuases every user (including eg lightdm) to try to spin up syncthing. Instead we need a better systemd user setup. For now I'm imperatively `systemctl --user enable syncthing` ewww.
      };
    };
}
