{
  flake.nixosModules.base =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];
    };
}
