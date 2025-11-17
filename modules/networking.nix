{
  flake.nixosModules.base =
    { config, ownerName, ... }:
    {
      networking.networkmanager.enable = true;
      users.users.${ownerName}.extraGroups = [ "networkmanager" ];
    };
}
