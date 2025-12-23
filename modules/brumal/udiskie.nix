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
      cfg = config.brumal.udiskie;
    in
    {
      options.brumal.udiskie.config = mkOption {
        type = types.attrsOf types.anything;
        default = { };
      };
      config.brumal.profile.packages = [
        pkgs.udiskie
      ];
      config.brumal.files.xdgConfig."udiskie/config.yml".text = attrsToYAML cfg.config;
    };
}
