{
  lib,
  evalBrumalModule,
  config,
inputs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    genAttrs
    filterAttrs
    mapAttrs
    mapAttrs'
    nameValuePair
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
      _: v: inputs.nixpkgs.lib.nixosSystem { inherit (v) system; modules = [ v.nixos ]; }
    ) machinesByDistro.nixos;

    nixphileConfigurations = mapAttrs (
      name: v:
      let
        legacyDotfiles-suffixed = mapAttrs' (name: rc: nameValuePair (name + "-rc") rc) v.legacyDotfiles;
      in
      config.flake.library.${v.system}.mergePackages {
        inherit name;
        packages =
          legacyDotfiles-suffixed
          // (if v.distro != "nixos" then (v.userPackages // v.systemPackages) else { });
      }
    ) machinesEvaluated;
  };
}
