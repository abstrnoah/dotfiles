{
  flake.machineModules.porcupine = {library, ...}: {
    networking.hostName = "porcupine";
    brumal.distro = "nixos";
    system.stateVersion = "25.05"; # Did you read the comment?
    nixpkgs.hostPlatform = library.mkDefault "x86_64-linux";

    # imports = [
    #   ./../hardware-configuration.nix
    # ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
