{
  flake.nixosModules.base =
    { library, config, ... }:
    {
      options.brumal.owner = library.mkOption {
        type = library.types.str;
      };
      config = {
        brumal.owner = "abstrnoah";
        users.users.${config.brumal.owner} = {
          isNormalUser = true;
        };
      };
    };
}
