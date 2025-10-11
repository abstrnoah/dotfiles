{
  flake.modules.nixos.machine =
    { library, config, ... }:
    library.mkCases config.brumal.distro {
      nixos.networking.networkmanager.enable = true;
      "*".users.users.${config.brumal.owner}.extraGroups = [ "networkmanager" ];
    };
}
