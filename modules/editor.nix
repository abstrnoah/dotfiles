{
  flake.modules.nixos.cl =
    { config, ... }:
    {
      environment.systemPackages = [ config.brumal.packages.vim ];
    };
}
