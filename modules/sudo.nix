{
  flake.nixosModules.base =
    { config, ownerName, ... }:
    {
      users.users.${ownerName}.extraGroups = [ "wheel" ];
    };
}
