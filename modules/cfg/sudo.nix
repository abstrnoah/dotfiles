{
  flake.nixosModules.base =
    { config, ... }:
    {
      users.users.${config.brumal.owner}.extraGroups = [ "wheel" ];
    };
}
