{
  flake.modules.nixos.base =
    { library, config, ... }:
    {
      options.brumal.env = library.mkOption { type = library.types.attrsOf library.types.str; };
      config.brumal.env = {
        XDG_CONFIG_HOME = "/home/${config.brumal.owner}/.config";
      };
    };
}
