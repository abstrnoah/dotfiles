{
  flake.nixosModules.base =
    {
      config,
      ownerName,
      pkgs,
      library,
      ...
    }:
    {
      environment.systemPackages = [ pkgs.dig ];
      networking.networkmanager.enable = true;
      users.users.${ownerName}.extraGroups = [ "networkmanager" ];
      networking.useDHCP = library.mkDefault true;
      services.mullvad-vpn.enable = true;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = true;
      };
    };
}
