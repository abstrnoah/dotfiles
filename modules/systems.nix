{
  # TODO Add Pi
  # TODO Generate from machine configurations
  systems = [ "x86_64-linux" ];

  flake.modules.nixos.system =
    { config, system, ... }:
    {
      _module.args.system = config.nixpkgs.hostPlatform.system;
    };
}
