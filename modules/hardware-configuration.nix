{
  flake.machineModules.porcupine =
    { library, ... }:
    {
      imports =
        if (library.pathExists ../var/hardware-configuration.nix) then
          [ ../var/hardware-configuration.nix ]
        else
          null;
    };
}
