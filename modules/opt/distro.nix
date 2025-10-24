{
  flake.nixosModules.brumal =
    { library, ... }:
    {
      options.brumal.distro = library.mkOption {
        type = library.types.str;
      };
    };
}
