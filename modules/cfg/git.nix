{
  flake.nixosModules.base.brumal.programs.git.config = {
    # TODO refactor user into owner
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
}
