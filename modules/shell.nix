{
  flake.nixosModules.base =
    {
      library,
      config,
      pkgs,
      ...
    }:
    let
      inherit (library) mkAfter getExe;
      bin = config.brumal.files.bin;
    in
    {
      brumal.bash = {
        inputrc = ''
          set bell-style none
          set editing-mode vi
          set keymap vi
        '';
        rc = ''
          alias T='${bin.gomux.source}'

          FZF_DEFAULT_OPTS="--border none"
          FZF_DEFAULT_OPTS+=" --color=bg:0"
          FZF_DEFAULT_OPTS+=" --reverse"
          FZF_DEFAULT_OPTS+=" --bind change:first"
          FZF_DEFAULT_OPTS+=" --bind tab:replace-query"
          FZF_DEFAULT_OPTS+=" --bind alt-enter:print-query"
          FZF_DEFAULT_OPTS+=" --bind ctrl-space:toggle"
          FZF_DEFAULT_OPTS+=" --bind ctrl-t:toggle-all"
          FZF_DEFAULT_OPTS+=" --bind ctrl-a:select-all"
          FZF_DEFAULT_OPTS+=" --bind ctrl-d:accept"
          export FZF_DEFAULT_OPTS

          if test -z $TMUX && test -z $BR_NOMUX; then
            ${bin.gomux.source}
          fi
        '';
      };
      programs.fzf.keybindings = true;
      programs.fzf.fuzzyCompletion = true;

      brumal.files.bin.oops.text = ''
        echo "$1" >/dev/stderr
        exit 1
      '';

      programs.direnv.enable = true;
      programs.direnv.silent = true;
      # Because direnv-instant conflicts
      programs.direnv.enableBashIntegration = false;
      programs.bash.interactiveShellInit = ''
        eval "$(direnv-instant hook bash)"
      '';
      environment.systemPackages = [ pkgs.direnv-instant ];
    };

  # TODO Remove, for testing
  perSystem =
    {
      utilities,
      inputs',
      pkgs,
      ...
    }:
    {
      overlayAttrs = {
        direnv-instant = inputs'.direnv-instant.packages.default;
      };
      direnvs.default.variables.foo = "bar";
      direnvs.default.packages = [ pkgs.cowsay ];
    };

}
