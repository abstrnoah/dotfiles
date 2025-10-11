# TODO A lot of this should be refactored, but I'm just trying a minimal working config.

{
  flake.machines.porcupine = {
    system = "x86_64-linux";
    distro = "nixos";
    hostname = "porcupine";
    owner.name = "abstrnoah";

    nixos = {
      imports = [
        # TODO Is this the best approach??
        /etc/nixoshardware-configuration.nix
      ];
    };
  };
}
