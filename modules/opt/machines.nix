{ library, config, ... }:
let
  inherit (library)
    evalBrumalModule
    mkOption
    types
    mapAttrs
    filterAttrs
    ;
  evalMachine =
    module:
    let
      e = evalBrumalModule {
        modules = [
          module
          config.flake.nixosModules.base
          config.flake.nixosModules.brumal
        ];
      };
    in
    e
    // {
      inherit (e.config.brumal.profile) switch rollback;
      profile = e.config.brumal.profile.package;
    };
in
{
  options.flake = {
    machineModules = mkOption {
      type = types.lazyAttrsOf types.deferredModule;
      default = { };
    };
    machines = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
      # TODO wrap with class and moduleLocation
    };
  };
  config.flake = {
    machines = mapAttrs (_: evalMachine) config.flake.machineModules or { };
    nixosConfigurations = filterAttrs (
      _: value: value.config.brumal.distro == "nixos"
    ) config.flake.machines;
  };
  # TODO Export in flakeModules?
}
