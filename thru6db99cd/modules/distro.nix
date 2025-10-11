{
  flake.modules.nixos.base =
    { library, config, ... }:
    {
      options.brumal.distro = library.mkOption {
        type = library.types.str;
      };
    };
}
