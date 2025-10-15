{
  flake.nixosModules.base =
    { config, ... }:
    {
      networking.networkmanager.enable = true;
      users.users.${config.brumal.owner}.extraGroups = [ "networkmanager" ];
    };
}
