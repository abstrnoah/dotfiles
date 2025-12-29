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
        scriptType
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
      bin = generateFiles "bin" "/bin" cfg.bin;
    in
    {
      options.brumal.files = {
        home = mkOption {
          type = filesType { executable = false; };
          default = { };
          description = "Dotfiles placed in `brumal.env.HOME` directory.";
        };
        xdgConfig = mkOption {
          type = filesType { executable = false; };
          default = { };
          description = "Dotfiles placed in `brumal.env.XDG_CONFIG_HOME` directory.";
        };
        bin = mkOption {
          type = types.attrsOf (scriptType { });
          default = { };
          description = "Ends up in profile's `/bin`.";
        };
      };
      config.brumal.profile.packages = filter (x: x != null) [
        home
        xdgConfig
        bin
      ];
    };
}
