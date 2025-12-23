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

      cfg = config.brumal.xresources;
      env = config.brumal.env;
      out = config.brumal.files.home.".Xresources".source;

      opts = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };
    in
    {
      options.brumal.xresources = opts;
      config.brumal.profile.postSwitch = [
        ''
          ${pkgs.xorg.xrdb}/bin/xrdb -merge ${out} \
          || echo "Warning: xrdb cannot connect"
        ''
      ];
      config.brumal.files.home.".Xresources".text =
        concatStringsSep "\n" (mapAttrsToList (resource: value: ''${resource}: ${value}'') cfg) + "\n";
    };
}
