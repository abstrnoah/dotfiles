# Inspired by https://github.com/lf-/flakey-profile
{
  flake.nixosModules.brumal =
    {
      library,
      utilities,
      config,
      pkgs,
      ownerName,
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
        concatScript
        writeText
        ;
      profileBaseName = config.networking.hostName + "-" + ownerName;
      env = config.brumal.env;
      postSwitchScript = concatScript "postSwitchScript" (
        map (s: writeText "script" (s + "\n")) config.brumal.profile.postSwitch
      );
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
        postSwitch = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
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
            nix-env --set "${config.brumal.profile.package}" "$@" \
            && ${pkgs.emplacetree}/bin/emplacetree ln "${env.NIX_PROFILE}/home/abstrnoah" "${env.HOME}" \
            && ${postSwitchScript}
          '';
        };
      };
    };
}
