{
  flake.nixosModules.brumal =
    {
      config,
      library,
      utilities,
      pkgs,
      ownerName,
      ...
    }:
    let
      inherit (library)
        types
        mkOption
        ;
      cfg = config.brumal.bash;
      opts = {
        rc = mkOption {
          type = types.lines;
          default = "";
        };
        profile = mkOption {
          type = types.lines;
          default = "";
        };
        inputrc = mkOption {
          type = types.lines;
          default = "";
        };
      };
      shell = pkgs.bash;
    in
    {
      options.brumal.bash = opts;
      config = {
        users.users.${ownerName}.shell = shell;
        environment.systemPackages = [ shell ];
        brumal.files.home = {
          ".bashrc".text = cfg.rc;
          ".bash_profile".text = cfg.profile;
          ".inputrc".text = cfg.inputrc;
        };
      };
    };
}
