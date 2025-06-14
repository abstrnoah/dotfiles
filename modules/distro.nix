{
  flake.modules.brumal.distro =
    { library, config, ... }:
    {
      options.brumal.distro = library.mkOption {
        type = library.types.str;
      };
    };
}
