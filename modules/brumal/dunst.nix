{
  flake.nixosModules.brumal =
  { pkgs, config, library, utilities, ...}:
  let
    inherit (library) mkOption types attrsToINI;
    inherit (utilities) writeTextFile;
    cfg = config.brumal.dunst;
    env = config.brumal.env;
    opts = {
      config = mkOption { type = types.attrsOf (types.attrsOf types.anything); };
    };
    rc = writeTextFile {
      name = "dunstrc";
      destination = "${env.XDG_CONFIG_HOME}/dunst/dunstrc";
      text = attrsToINI {} cfg.config;
    };
  in
  {
    options.brumal.dunst = opts;
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
      brumal.profile.packages = [ rc ];
    };
  };
}
