{
  flake.nixosModules.brumal =
    {
      config,
      pkgs,
      utilities,
      library,
      ...
    }:
    let
      inherit (library)
        types
        mkOption
        attrsToGitINI
        ;
      cfg = config.brumal.programs.git;
      opts = {
        config = mkOption {
          description = "Git config, to be written via nixpkgs' toGitINI.";
          type = types.attrsOf (types.attrsOf types.anything);
        };
      };
      configPkg = utilities.writeTextFile {
        name = ".gitconfig";
        destination = "${config.brumal.env.HOME}/.gitconfig";
        text = attrsToGitINI cfg.config;
      };
    in
    {
      options.brumal.programs.git = opts;
      config = {
        environment.systemPackages = [ pkgs.git ];
        brumal.profile.packages = [ configPkg ];
      };

      config.brumal.programs.git.config = {
        user.name = config.brumal.owner;
      };
    };
}
