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
        mkDefault
        attrsToGitINI
        ;
      cfg = config.brumal.git;
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
      options.brumal.git = opts;
      config = {
        environment.systemPackages = [ pkgs.git ];
        brumal.profile.packages = [ configPkg ];
      };

      config.brumal.git.config = {
        user.name = mkDefault config.brumal.owner.name;
        user.email = mkDefault config.brumal.owner.email;
        user.signingkey = mkDefault config.brumal.owner.pgpkey;
      };
    };
}
