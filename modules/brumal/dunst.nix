{
  flake.nixosModules.brumal =
    {
      pkgs,
      config,
      library,
      utilities,
      ...
    }:
    let
      inherit (library) mkOption types attrsToINI;
      cfg = config.brumal.dunst;
      env = config.brumal.env;
    in
    {
      options.brumal.dunst = {
        config = mkOption { type = types.attrsOf (types.attrsOf types.anything); };
      };
      config = {
        services.dbus.packages = [
          pkgs.dunst
        ];
        systemd.packages = [
          pkgs.dunst
        ];
        environment.systemPackages = [
          pkgs.libnotify
          pkgs.dunst
        ];
        brumal.files.xdgConfig."dunst/dunstrc".text = attrsToINI { } cfg.config;
      };
    };
}
