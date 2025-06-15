{
  flake.machineModules.coyote = {
    networking.hostName = "coyote";
    brumal.distro = "debian";
    nixpkgs.hostPlatform = "x86_64-linux";

    # TODO
  };
}
