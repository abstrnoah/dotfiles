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
      # TODO make more declarative
      systemd.user.units."syncthing.service".text =
        readFile "${pkgs.syncthing}/share/systemd/user/syncthing.service";
    };
}
