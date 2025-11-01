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
        writeTextFile
        ;

      cfg = config.brumal.programs.xresources;
      env = config.brumal.env;

      opts = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };

      xresourcesP = writeTextFile {
        name = "Xresources";
        destination = "${env.HOME}/.Xresources";
        text =
          concatStringsSep "\n" (mapAttrsToList (resource: value: ''${resource}: ${value}'') cfg) + "\n";
      };
    in
    {
      options.brumal.programs.xresources = opts;
      config.brumal.profile.packages = [ xresourcesP ];
      config.brumal.profile.postSwitch = [
        ''
          ${pkgs.xorg.xrdb}/bin/xrdb -merge ${xresourcesP}/${env.HOME}/.Xresources \
          || echo "Warning: xrdb cannot connect"
        ''
      ];
    };
}
