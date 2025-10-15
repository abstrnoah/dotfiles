{ library, config, ... }:
let
  evalMachine =
    module:
    let
      e = library.evalBrumalModule {
        modules = [
          module
          config.flake.nixosModules.base
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
    machineModules = library.mkOption {
      type = library.types.lazyAttrsOf library.types.deferredModule;
      default = { };
    };
    machines = library.mkOption {
      type = library.types.lazyAttrsOf library.types.raw;
      default = { };
      # TODO wrap with class and moduleLocation
    };
  };
  config.flake = {
    machines = library.mapAttrs (_: evalMachine) config.flake.machineModules or { };
    nixosConfigurations = library.filterAttrs (
      _: value: value.config.brumal.distro == "nixos"
    ) config.flake.machines;
  };

}
