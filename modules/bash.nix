top@{ ... }:
{
  flake.nixosModules.base =
    {
      config,
      library,
      pkgs,
      ...
    }:
    let
      inherit (library)
        mkEnableOption
        mkPackageOption
        types
        mkIf
        ;
      cfg = config.brumal.programs.bash;
      opts = {
        # enable = mkEnableOption "bash";
        package = mkPackageOption "bash";
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
    in
    {
      options.brumal.programs.bash = opts;
      config = {
        brumal.programs.bash = {
          # enable = true;
          package = pkgs.bash;
          inputrc = [
            "set bell-style none"
            "set editing-mode vi"
            "set keymap vi"
          ];
        };
        users.users.${config.brumal.owner}.shell = cfg.package;
        environment.systemPackages = [ cfg.package ];
        brumal.profile.packages = [
          rcP
          profileP
          inputrcP
        ];
      };
    };
}
