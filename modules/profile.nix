# Inspired by https://github.com/lf-/flakey-profile
{
  flake.nixosModules.base =
    {
      library,
      utilities,
      config,
      pkgs,
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
      env = config.brumal.env;
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
          # TODO make atomic!
          text = ''
            nix-env --set "${config.brumal.profile.package}" "$@"
            ${pkgs.emplacetree}/bin/emplacetree ln "${env.NIX_PROFILE}/home/abstrnoah" "${env.HOME}"
          '';
        };
        rollback = writeShellApplication {
          name = profileBaseName + "-rollback";
          text = ''
            nix-env --rollback "$@"
            ${pkgs.emplacetree}/bin/emplacetree ln "${env.NIX_PROFILE}/home/abstrnoah" "${env.HOME}"
          '';
        };
      };
    };
}
