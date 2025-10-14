top@{ config, ... }:
{
  flake.machineModules.porcupine =
    { library, ... }:
    {
    imports = [
      top.config.flake.nixosModules.base
    ];
  };
}
