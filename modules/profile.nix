# Inspired by https://github.com/lf-/flakey-profile
{
  flake.nixosModules.base =
    {
      library,
      utilities,
      config,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        attrValues
        ;
      inherit (utilities)
        buildEnv
        writeShellApplication
        ;
      profileBaseName = config.networking.hostName + "-" + config.brumal.owner;
    in
    {
      options.brumal.profile = {
        packages = mkOption {
          type = types.listOf types.package;
          default = [ ];
        };
        package = mkOption { type = types.package; };
        switch = mkOption { type = types.package; };
        rollback = mkOption { type = types.package; };
      };
      config.brumal.profile = {
        package = buildEnv {
          name = profileBaseName;
          paths = config.brumal.profile.packages;
          extraOutputsToInstall = [
            "man"
            "doc"
          ];
        };
        switch = writeShellApplication {
          name = profileBaseName + "-switch";
          text = ''
            nix-env --set ${config.brumal.profile.package} "$@"
            # TODO emplacetree
          '';
        };
        rollback = writeShellApplication {
          name = profileBaseName + "-rollback";
          text = ''
            nix-env --rollback "$@"
            # TODO emplacetree
          '';
        };
      };
    };
}
