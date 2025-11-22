{
  flake.nixosModules.brumal-wm =
    {
      config,
      library,
      utilities,
      pkgs,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        attrsToYAML
        ;
      inherit (utilities)
        writeTextFile
        ;
      cfg = config.brumal.udiskie;
      env = config.brumal.env;
      rc = writeTextFile {
        name = "config.yml";
        destination = "${env.XDG_CONFIG_HOME}/udiskie/config.yml";
        text = attrsToYAML cfg.config;
      };
    in
    {
      options.brumal.udiskie.config = mkOption {
        type = types.attrsOf types.anything;
        default = { };
      };
      config.brumal.profile.packages = [
        pkgs.udiskie
        rc
      ];
    };
}
