{ config, ... }:
{
  flake.modules.brumal.base.imports = [
    config.flake.modules.brumal.distro
    config.flake.modules.brumal.owner
    config.flake.modules.brumal.profile
    config.flake.modules.brumal.system
    config.flake.modules.brumal.utilities
    config.flake.modules.brumal.nixpkgs
  ];
}
