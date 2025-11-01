{
  flake.nixosModules.brumal =
    {
      library,
      config,
      utilities,
      pkgs,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        mapAttrsToList
        concatStringsSep
        ;

      inherit (utilities)
        writeText
        ;

      cfg = config.brumal.programs.xresources;
      env = config.brumal.env;

      opts = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };

      xresourcesP = writeText "Xresources" (
        concatStringsSep "\n" (mapAttrsToList (resource: value: ''${resource}: ${value}'') cfg) + "\n"
      );
    in
    {
      options.brumal.programs.xresources = opts;
      config.brumal.profile.postSwitch = [
        ''${pkgs.xorg.xrdb}/bin/xrdb -merge ${xresourcesP} || echo "Warning: xrdb cannot connect"''
      ];
    };
}
