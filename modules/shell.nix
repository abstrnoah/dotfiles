{
  flake.nixosModules.base =
    {
      library,
      config,
      pkgs,
      ...
    }:
    let
      inherit (library) mkAfter getExe mkOrder;
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
          FZF_DEFAULT_OPTS+=" --bind enter:accept-or-print-query"
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
      # TODO
      # For some reason I cannot understand this is necessary _for tmux only_.
      # Yeah outside of tmux putting this block above works fine.
      # Shouldn't my ~/.bashrc be sourced after /etc/bashrc?
      # Apparently not? But just for tmux??!?!?!?!?!
      # We have to use 1600 because fzf is already installed at mkAfter's 1500 🤡
      programs.bash.promptPluginInit = mkOrder 1600 ''
        # Remap fzf-cd to ctrl-g
        bind -m emacs-standard -r '\ec'
        bind -m vi-command -r '\ec'
        bind -m vi-insert -r '\ec'
        bind -m emacs-standard '"\C-g": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d\C-y\ey\C-_"'
        bind -m vi-command '"\C-g": "\C-z\C-g\C-z"'
        bind -m vi-insert '"\C-g": "\C-z\C-g\C-z"'
      '';
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
      brumal.files.bin.treeg.text = "${pkgs.tree}/bin/tree --gitignore";
      brumal.files.bin.bathelp.text = ''
        ${pkgs.bat}/bin/bat --plain --language help "$@"
      '';
      brumal.files.bin.belp.text = ''
        ("$@" -h || "$@" --help) 2>/dev/null | ${bin.bathelp.source};
      '';

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
}
