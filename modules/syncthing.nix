{
  flake.modules.brumal.syncthing =
    {
      packages,
      config,
      mkCases,
      library,
      ...
    }:
    let
      syncthing-service =
        library.storeSymlink "syncthing-service"
          "${packages.syncthing}/share/systemd/user/syncthing.service"
          "/home/me/.config/systemd/user/syncthing.service";
    in
    {
      userPackages = { inherit (packages) syncthing; };
      legacyDotfiles = mkCases config.distro { debian = { inherit syncthing-service; }; };
    };

}
