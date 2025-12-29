{
  flake.nixosModules.brumal =
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
        mkDefault
        mkIf
        mkDerivedConfig
        replaceStrings
        mapAttrsToList
        getAttrs
        filter
        ;
      inherit (utilities)
        writeText
        storeSymlinks
        filesType
        ;
      cfg = config.brumal.files;
      env = config.brumal.env;
      generateFiles =
        name: destination: files:
        if files != { } then
          storeSymlinks {
            name = "brumal-${name}";
            inherit destination;
            mapping = mapAttrsToList (
              name:
              getAttrs [
                "source"
                "target"
              ]
            ) files;
          }
        else
          null;
      home = generateFiles "home" env.HOME cfg.home;
      xdgConfig = generateFiles "xdg-config" env.XDG_CONFIG_HOME cfg.xdgConfig;
    in
    {
      options.brumal.files = {
        home = mkOption {
          type = filesType;
          default = { };
          description = "Dotfiles placed in `brumal.env.HOME` directory.";
        };
        xdgConfig = mkOption {
          type = filesType;
          default = { };
          description = "Dotfiles placed in `brumal.env.XDG_CONFIG_HOME` directory.";
        };
      };
      config.brumal.profile.packages = filter (x: x != null) [
        home
        xdgConfig
      ];
    };
}
