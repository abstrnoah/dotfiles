{ library, config, ... }:
let
  evalMachine =
    module:
    let
      e = library.evalBrumalModule {
        modules = [
          module
          config.flake.modules.brumal.base
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
  options.flake.machines = library.mkOption {
    type = library.types.lazyAttrsOf library.types.raw;
    default = { };
  };
  config.flake.machines = library.mapAttrs (_: evalMachine) config.flake.modules.machine;
  config.flake.nixosConfigurations = library.filterAttrs (
    _: value: value.brumal.distro == "nixos"
  ) config.flake.machines;
}
