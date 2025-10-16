{
  # TODO Add Pi
  # TODO Generate from machine configurations
  systems = [ "x86_64-linux" ];

  flake.nixosModules.base =
    { config, ... }:
    {
      _module.args.system = config.nixpkgs.hostPlatform.system;
    };
}
