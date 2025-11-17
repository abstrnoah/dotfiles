{
  flake.nixosModules.brumal =
    { library, config, ... }:
    let
      inherit (library)
        mkOption
        types
        getName
        ;
      opts.allowUnfree = mkOption { type = types.listOf types.str; };
      cfg = config.brumal.nixpkgs;
    in
    {
      options.brumal.nixpkgs = opts;
      config.nixpkgs.config = {
        allowUnfreePredicate = pkg: builtins.elem (getName pkg) cfg.allowUnfree;
      };
    };
}
