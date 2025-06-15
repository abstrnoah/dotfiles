{
  flake.modules.nixos.owner =
    { library, config, ... }:
    {
      options.brumal.owner = library.mkOption {
        type = library.types.str;
      };
      config.brumal.owner = "abstrnoah";
    };
}
