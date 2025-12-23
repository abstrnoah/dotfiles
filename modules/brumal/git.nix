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
    in
    {
      options.brumal.git = opts;
      config = {
        environment.systemPackages = [ pkgs.git ];
        brumal.files.home.".gitconfig".text = attrsToGitINI cfg.config;
      };

      config.brumal.git.config = {
        user.name = mkDefault config.brumal.owner.name;
        user.email = mkDefault config.brumal.owner.email;
        user.signingkey = mkDefault config.brumal.owner.pgpkey;
      };
    };
}
