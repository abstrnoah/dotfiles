{
  flake.nixosModules.base =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.vim ];
    };
}
