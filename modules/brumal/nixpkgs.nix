{
  flake.nixosModules.brumal =
    { library, config, ... }:
    let
      inherit (library)
        mkOption
        types
        getName
        ;
      cfg = config.brumal.nixpkgs;
    in
    {
      options.brumal.nixpkgs.allowUnfree = mkOption { type = types.listOf types.str; };
      config.nixpkgs.config = {
        allowUnfreePredicate = pkg: builtins.elem (getName pkg) cfg.allowUnfree;
      };
    };
}
