# Inspired by https://github.com/lf-/flakey-profile
{
  flake.modules.nixos.profile =
    { library, utilities, config, ... }:
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
      options.brumal = {
        packages = mkOption {
          type = types.lazyAttrsOf types.package;
          default = { };
        };
        rcs = mkOption {
          type = types.lazyAttrsOf types.package;
          default = { };
        };
        profile.package = mkOption {
          type = types.package;
        };
        profile.switch = mkOption {
          type = types.package;
        };
        profile.rollback = mkOption {
          type = types.package;
        };
      };
      config.brumal = {
        profile.package = buildEnv {
          name = profileBaseName;
          paths = (attrValues config.brumal.packages) ++ (attrValues config.brumal.rcs);
          extraOutputsToInstall = [
            "man"
            "doc"
          ];
        };
        profile.switch = writeShellApplication {
          name = profileBaseName + "-swtich";
          text = ''
            nix-env --set ${config.brumal.profile.package} "$@"
            # TODO emplacetree
          '';
        };
        profile.rollback = writeShellApplication {
          name = profileBaseName + "-rollback";
          text = ''
            nix-env --rollback "$@"
            # TODO emplacetree
          '';
        };
      };
    };
}
