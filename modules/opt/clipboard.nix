{
  flake.nixosModules.brumal =
    {
      library,
      pkgs,
      config,
      ...
    }:
    let
      inherit (library) mkOption types;
      cfg = config.brumal.clipboard;
      opts = {
        package = mkOption { type = types.package; };
        selection = mkOption { type = types.str; };
        yank = mkOption { type = types.str; };
        paste = mkOption { type = types.str; };
      };
    in
    {
      options.brumal.clipboard = opts;
      config.environment.systemPackages = [ cfg.package ];
    };
}
