{
  flake.nixosModules.brumal =
    { library, ... }:
    let
      inherit (library) mkOption types;
    in
    {
      options.brumal.env = mkOption { type = types.attrsOf types.str; };
    };
}
