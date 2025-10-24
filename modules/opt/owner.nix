{
  flake.nixosModules.brumal =
    { library, config, ... }:
    {
      options.brumal.owner = library.mkOption {
        type = library.types.str;
      };
      config = {
        users.users.${config.brumal.owner} = {
          isNormalUser = true;
        };
      };
    };
}
