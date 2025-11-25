{
  flake.nixosModules.gui =
    {
      config,
      library,
      utilities,
      pkgs,
      ...
    }:
    let

      inherit (library) mapAttrs;
      inherit (utilities) writeShellApplication;
      cfg = config.brumal.i3wm;
      k = cfg.keys;
      env = config.brumal.env;
      dims = library.mapAttrs (_: builtins.toString) cfg.dimensions;

    in
    {

      brumal.i3wm.body.bindsym = {
        o = "focus output right";
        "${k.alt}+o" = "move workspace to output right";
      };

    };
}
