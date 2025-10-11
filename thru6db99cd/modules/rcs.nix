{
  flake.modules.nixos.base =
    { library, ... }:
    {
      options.brumal.rcs = library.mkOption {
        type = library.types.lazyAttrsOf library.types.package;
        default = { };
      };
    };
}
