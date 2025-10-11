# Full command-line environment, no gui.
# TODO This has become a de facto base module, consider refactoring.

top@{ config, ... }:
{
  flake.modules.brumal.cl =
    {
      packages,
      library,
      system,
      config,
      mkCases,
      ...
    }:
    {
      imports = builtins.attrValues {
        inherit (top.config.flake.modules.brumal)
          curl
          git
          tmux
          tmuxinator
          vim
          visidata
          nix
          dict
          ttdl
          bluetooth
          tex
          crypt
          zsh
          ;
      };

      config = mkCases config.distro {
        "*".userPackages = {
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

        "*".legacyDotfiles.cl = library.storeLegacyDotfiles "cl";

        nixos.nixos.nixpkgs.config = top.config.nixpkgs-config;
      };
    };
}
