{
  flake.nixosModules.brumal =
    { config, ... }:
    {
      _module.args.system = config.nixpkgs.hostPlatform.system;
    };
}
