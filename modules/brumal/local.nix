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
            At runtime, the local config is sourced, making its variables available.
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
          source ${cfg.path}
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
