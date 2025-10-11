{ library, config, ... }:
let
  evalMachine =
    module:
    let
      e = library.evalBrumalModule {
        modules = [
          module
          config.flake.modules.nixos.base
          # config.flake.modules.nixos.machine
        ];
      };
    in
    e
    // {
      inherit (e.brumal.profile) switch rollback;
      profile = e.brumal.profile.package;
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
    # modules.nixos = config.flake.machineModules;
    machines = library.mapAttrs (_: evalMachine) config.flake.machineModules or { };
    nixosConfigurations = library.filterAttrs (
      _: value: value.brumal.distro == "nixos"
    ) config.flake.machines;
  };

}
