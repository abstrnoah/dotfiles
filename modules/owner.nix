{
  flake.modules.brumal.owner =
    { library, config, ... }:
    {
      options.brumal.owner = library.mkOption {
        type = library.types.str;
      };
      config.brumal.owner = "abstrnoah";
    };
}
