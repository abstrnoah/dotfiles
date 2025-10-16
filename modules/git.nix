{
  flake.nixosModules.base =
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
          description = "GIt config, to be written via nixpkgs' toGitINI.";
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
        # TODO refactor into owner
        user.email = "abstrnoah@brumal.net";
        user.signingKey = "A99804C0F82B99C88DAF2CFD39436096D08807E8";
        merge.conflict = "diff3";
        push.default = "simple";
        pull.ff = "only";
        init.defaultBranch = "main";
        tag.gpgSign = true;
        alias = {
          log- = "log --oneline --decorate --graph";
          diff- = "diff --color-words";
          update = "commit -a -m update";
        };
      };
    };
}
