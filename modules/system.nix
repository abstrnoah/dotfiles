{
  flake.modules.brumal.system =
    { config, ... }:
    {
      _module.args.system = config.nixpkgs.hostPlatform;
    };
}
