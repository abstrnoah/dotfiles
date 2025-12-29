# TODO Do it better
{
  flake.nixosModules.brumal =
    {
      config,
      library,
      pkgs,
      utilities,
      ...
    }:
    let
      inherit (library)
        types
        mkOption
        escapeShellArg
        concatStringsSep
        ;
      inherit (utilities)
        writeShellApplication
        ;
      baseName = config.networking.hostName + "-localconfig";
      cfg = config.brumal.local;
      opts = {
        switch = mkOption {
          description = "Run independently of profile.switch, activates local config.";
          type = types.package;
        };
        hooks = mkOption {
          description = ''
            Hooks to run when switching local config.
            These should be fast and idempotent.
          '';
          type = types.listOf types.lines;
          default = [ ];
        };
        path = mkOption {
          description = "Path to local env file.";
          type = types.str;
          default = "/persist/local.env";
        };
        values = mkOption {
          type = types.attrsOf types.str;
        };
        variables = mkOption {
          type = types.attrsOf (
            types.submodule (
              {
                name,
                config,
                options,
                ...
              }:
              {
                options = {
                  default = mkOption { type = types.str; };
                  shellValue = mkOption { type = types.str; };
                  name = mkOption { type = types.str; };
                };
                config = {
                  inherit name;
                  shellValue = ''"$(source ${escapeShellArg cfg.path} && echo "''${${config.name}:-${config.default}}")"'';
                };
              }
            )
          );
          default = { };
        };
      };
      switchScript = writeShellApplication {
        name = baseName + "-switch";
        text = ''
          if ! test -f ${cfg.path}; then
            echo "No config found: ${cfg.path}" >/dev/stderr
            exit 1
          fi
          # TODO
          # shellcheck source=/dev/null
          ${concatStringsSep "\n" cfg.hooks}
        '';
      };
    in
    {
      options.brumal.local = opts;
      config = {
        brumal.local.switch = switchScript;
        brumal.profile.postSwitch = [
          ''sudo ${cfg.switch}/bin/${baseName + "-switch"}''
        ];
      };
    };
}
