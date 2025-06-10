# Full command-line environment, no gui.

top@{ config, ... }:
{
  flake.modules.brumal.cl =
    {
      packages,
      library,
      system,
      config,
      ...
    }:
    {
      imports = builtins.attrValues {
        inherit (top.config.flake.modules.brumal)
          curl
          git
          tmux
          vim
          visidata
          nix
          dict
          ttdl
          bluetooth
          tex
          ;
      };

      userPackages = {
        inherit (packages)
          awk
          nixphile
          diffutils
          dos2unix
          findutils
          getconf
          gnugrep
          gnused
          hostname
          man
          bat
          dig
          dnstracer
          fd
          sd
          rargs
          fzf
          htop
          jq
          netcat-openbsd
          nettools
          nodejs
          pandoc
          pdfgrep
          neofetch
          nnn
          silver-searcher
          sl
          textql
          time
          toilet
          tree
          tuptime
          universal-ctags
          zip
          rlwrap
          par
          util-linux
          coreutils
          emplacetree
          restic
          clang
          cowsay
          exiftool
          gcal
          pdftk
          nixfmt
          uni
          numbat
          ;

      };

      legacyDotfiles.cl = library.storeLegacyDotfiles "cl";
    };
}
