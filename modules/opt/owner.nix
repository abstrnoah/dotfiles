{
  flake.nixosModules.brumal =
    {
      library,
      config,
      ownerName,
      ...
    }:
    let
      inherit (library) mkOption types;
      opts = {
        name = mkOption { type = types.str; };
        email = mkOption { type = types.str; };
        pgpkey = mkOption { type = types.str; };
      };
    in
    {
      options.brumal.owner = opts;
      config = {
        users.users.${ownerName} = {
          isNormalUser = true;
        };
        _module.args.ownerName = config.brumal.owner.name;
      };
    };
}
