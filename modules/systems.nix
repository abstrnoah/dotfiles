{
  # TODO Add Pi
  # TODO Generate from machine configurations
  systems = [ "x86_64-linux" ];

  flake.nixosModules.base =
    { config, system, ... }:
    {
      _module.args.system = config.nixpkgs.hostPlatform.system;
    };
}
