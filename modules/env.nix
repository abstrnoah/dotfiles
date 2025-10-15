{
  flake.nixosModules.base =
    { library, config, ... }:
    {
      options.brumal.env = library.mkOption { type = library.types.attrsOf library.types.str; };
      config.brumal.env = rec {
        HOME = "/home/${config.brumal.owner}";
        XDG_CONFIG_HOME = "${HOME}/.config";
      };
    };
}
