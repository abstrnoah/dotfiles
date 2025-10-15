top@{ config, ... }:
{
  flake.machineModules.porcupine =
    { library, ... }:
    {
      networking.hostName = "porcupine";
      brumal.distro = "nixos";
      system.stateVersion = "25.05"; # "Do not change this value..."
      nixpkgs.hostPlatform = library.mkDefault "x86_64-linux";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      imports = [
        top.config.flake.nixosModules.base
      ];
    };
}
