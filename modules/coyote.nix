{ config, evalBrumalModule, ... }:
{
  flake.machines.coyote = {
    system = "x86_64-linux";
    distro = "debian";
    hostname = "coyote";
    owner.name = "abstrnoah";
    imports = [ config.flake.modules.brumal.cl ];
  };
}
