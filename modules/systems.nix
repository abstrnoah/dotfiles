{
  # TODO Add Pi
  # TODO Generate from machine configurations
  systems = [ "x86_64-linux" ];

  flake.modules.brumal.system =
    { config, ... }:
    {
      _module.args.system = config.nixpkgs.hostPlatform;
    };
}
