{
  lib,
  evalBrumalModule,
  config,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    genAttrs
    filterAttrs
    nixosSystem
    mapAttrs
    ;
  machinesEvaluated = mapAttrs (_: evalBrumalModule) config.flake.machines;
  machinesByDistro = genAttrs [
    "debian"
    "nixos"
  ] (distro: (filterAttrs (_: v: v.distro == distro) machinesEvaluated));
in
{
  options.flake = {
    machines = mkOption {
      type = types.lazyAttrsOf types.deferredModule;
      description = ''
        Brumal modules representing machines.
      '';
    };
    nixphileConfigurations = mkOption {
      type = types.lazyAttrsOf types.package;
      description = ''
        Packages meant to be deployed via nixphile.
      '';
    };
  };

  config.flake = {
    nixosConfigurations = mapAttrs (
      _: v: nixosSystem { modules = [ v.nixos ]; }
    ) machinesByDistro.nixos;

    nixphileConfigurations = mapAttrs (
      name: v:
      config.flake.library.${v.system}.mergePackages {
        inherit name;
        packages =
          v.legacyDotfiles // (if v.distro != "nixos" then (v.userPackages // v.systemPackages) else { });
      }
    ) machinesEvaluated;
  };
}
