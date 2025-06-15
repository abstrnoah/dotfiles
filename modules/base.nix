{ config, ... }:
{
  flake.modules.nixos.base.imports = [
    config.flake.modules.nixos.distro
    config.flake.modules.nixos.owner
    config.flake.modules.nixos.profile
    config.flake.modules.nixos.system
    config.flake.modules.nixos.utilities
    config.flake.modules.nixos.nixpkgs
  ];
}
