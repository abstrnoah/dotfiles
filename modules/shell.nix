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
      brumal.files.bin.withcd.text = ''
        if test "$#" -eq 0; then
          exit 1
        fi
        old_path="$PWD"
        cd "$1"
        shift
        "$@"
        cd "$old_path"
      '';

      programs.direnv.enable = true;
      programs.direnv.silent = false;
      # Because direnv-instant conflicts
      programs.direnv.enableBashIntegration = false;
      programs.bash.interactiveShellInit = ''
        eval "$(direnv-instant hook bash)"
        alias nix='BR_SHELL_NESTING="$BR_SHELL_NESTING " nix'
        alias nix-shell='BR_SHELL_NESTING="$BR_SHELL_NESTING " nix-shell'
      '';
      environment.systemPackages = [ pkgs.direnv-instant ];

      programs.starship.enable = true;
      programs.starship.settings = {

        format = "$username$hostname$directory$git_branch$git_commit$git_state$git_metrics$git_status$direnv$cmd_duration$status$nix_shell$line_break\${env_var.BR_SHELL_NESTING}$jobs$character";

        directory.format = "[$path]($style)[/](bold)[$read_only]($read_only_style) ";

        character.success_symbol = "[⊢](bold green)";
        character.error_symbol = "[⊢](bold red)";

        status.disabled = false;
        status.format = "[$status󰌑]($style) ";

        cmd_duration.format = "[ $duration]($style) ";

        jobs.symbol = "󰇘";

        battery.disabled = true;

        # In practice, for me, nix_shell detects direnv
        # and BR_SHELL_NESTING detects interactive invocation of 'nix shell'
        nix_shell.format = "[$symbol]($style) ";
        nix_shell.symbol = "❄️";
        nix_shell.heuristic = false; # Doesn't work for me
        env_var.BR_SHELL_NESTING.format = "$env_value"; # No trailing space bc value already spaced

        # Starship has an open issue about direnv, so we disable for now
        direnv.format = "[$loaded$allowed]($style) ";
        direnv.disabled = true;
        direnv.symbol = "";
        direnv.not_allowed_msg = "󱧊 ";
        direnv.denied_msg = "󰷌 ";
        direnv.allowed_msg = "";
        direnv.unloaded_msg = "󰕂 ";
        direnv.loaded_msg = "󱥾 ";

        git_branch.format = "[$symbol$branch(:$remote_branch)]($style) ";
        git_branch.style = "bold yellow";
        git_branch.symbol = "";

        username.format = "[$user]($style) ";

        hostname.format = "[$hostname]($style)$ssh_symbol ";
        hostname.ssh_symbol = "󰢩";
      };
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
