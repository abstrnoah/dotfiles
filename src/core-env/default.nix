config@{ shell, bundle, store-source, substitute }:
packages@{ awk, nixphile, diffutils, dos2unix, findutils, getconf, gnugrep
, gnused, hostname, man, bat, curl, dig, dnstracer, fd, sd, rargs, fzf, git
, htop, jq, netcat-openbsd, nettools, nodejs, pandoc, pdfgrep, neofetch, nnn
, silver-searcher, sl, textql, time, tmux, toilet, tree, tuptime
, universal-ctags, zip, neovim, visidata, rlwrap, par, nix-rc, util-linux
, coreutils, emplacetree }:

let
  core-rc = store-source {
    source = ./.;
    excludes = [ "README.md" "default.nix" "etc/shells" ];
  };
  shells = substitute {
    src = ./etc/shells;
    dir = "etc";
    replacements = [ "--replace-fail" "@shell@" shell ];
  };

in bundle {
  name = "core-env";
  packages = packages // { inherit core-rc shells; };
}
