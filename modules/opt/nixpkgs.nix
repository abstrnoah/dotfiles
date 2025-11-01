{
  flake.nixosModules.brumal =
    { library, config, ... }:
    let
      inherit (library)
        mkOption
        types
        getName
        ;
      opts.allowUnfree = mkOption { type = types.listOf types.package; };
      cfg = config.brumal.programs.nixpkgs;
    in
    {
      options.brumal.programs.nixpkgs = opts;
      config.nixpkgs.config = {
        allowUnfreePredicate = pkg: builtins.elem (getName pkg) cfg.allowUnfree;
      };
    };
}
