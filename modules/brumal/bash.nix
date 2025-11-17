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
          type = types.str;
          default = "";
        };
        profile = mkOption {
          type = types.str;
          default = "";
        };
        inputrc = mkOption {
          type = types.lines;
          default = "";
        };
      };
      writeRc =
        name: text:
        utilities.writeTextFile {
          inherit name text;
          destination = "${config.brumal.env.HOME}/${name}";
        };
      rcP = writeRc ".bashrc" cfg.rc;
      profileP = writeRc ".bash_profile" cfg.profile;
      inputrcP = writeRc ".inputrc" cfg.inputrc;
      shell = pkgs.bash;
    in
    {
      options.brumal.bash = opts;
      config = {
        users.users.${ownerName}.shell = shell;
        environment.systemPackages = [ shell ];
        brumal.profile.packages = [
          rcP
          profileP
          inputrcP
        ];
      };
    };
}
