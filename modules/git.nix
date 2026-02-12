{
  flake.nixosModules.base.brumal.git.config = {
    merge.conflict = "diff3";
    push.default = "simple";
    pull.ff = "only";
    init.defaultBranch = "main";
    tag.gpgSign = true;
    alias = {
      log- = "log --oneline --decorate --graph";
      loga = "log- --all";
      diff- = "diff --color-words";
      update = "commit -a -m update";
    };
    core.askPass = "";
  };
}
