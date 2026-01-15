{
  flake.nixosModules.base =
    { pkgs, config, ... }:
    {
      brumal.files.bin.gomux.runtimeInputs = [
        pkgs.coreutils
        pkgs.tmux
        config.brumal.files.bin.oops.package
      ];
      brumal.files.bin.gomux.text = ''
        if test "$#" -eq 0; then
          tmux a >&2 2>/dev/null || $0 "$HOME" home
          exit
        fi

        startDirectory="$(readlink -f "$1")"
        startDirectory="''${startDirectory:-.}"
        sessionName="''${2:-''$(basename "$startDirectory")}"
        sessionName="''${sessionName//./_}" # Dots confuse tmux

        if ! tmux has-session -t="$sessionName" 2>/dev/null; then
          test -d "$startDirectory" \
            || oops "Directory not found: $startDirectory" || exit
          tmux new-session -d -s "$sessionName" -c "$startDirectory"
        fi

        if test -z "''${TMUX:-}"; then
          tmux attach -t "$sessionName"
        else
          tmux switch-client -t "$sessionName"
        fi
      '';

      brumal.files.bin.tmux-choose-session.runtimeInputs = [
        pkgs.tmux
        pkgs.fzf
        config.brumal.files.bin.gomux.package
      ];
      brumal.files.bin.tmux-choose-session.text = ''
        fzf() {
          fzf-tmux -w 25 -- --prompt="session> "
        }
        read -ra args < <(tmux list-sessions -F '#S' | fzf) || exit 0
        args=("''${args[@]/'~'/$HOME}")
        gomux "''${args[@]}"
      '';

      brumal.tmux = {

        # TODO finish deprecating tmuxinator and just use gomux instead, it is now out of date with tmux
        tmuxinator = {

          main = ''
            name: main
            root: ~/<%= @args[0] %>

            windows:
              - null:
          '';

          monitor = ''
            name: monitor
            root: ~/

            windows:
              - htop: htop
              - temp: watch -n 300 cat /sys/class/thermal/thermal_zone*/temp
              - syslog: journalctl -f
              - userlog: journalctl --user -f
          '';

        };

        conf = ''
          # CONSTANTS
          BR_TMUX_PROMPT_LEFT="❱"
          BR_TMUX_PROMPT_RIGHT="❰"

          # SETUP
          set    -g default-terminal tmux-256color

          set -w -g main-pane-width 87
          # Debug layout: narrow pane on bottom for debug server, large main pane above.
          bind M-6 select-layout a530,194x56,0,0[194x42,0,0,5,194x13,0,43,9]

          # STATUS
          set    -g set-titles on
          set    -g set-titles-string "#S [#h]"
          set -g status-interval 10
          set    -g status-position top
          set    -g status-style 'bg=colour0,fg=colour14,bold'
          set    -g status-left "#S$BR_TMUX_PROMPT_LEFT "
          set    -g status-left-length 50
          set    -g window-status-current-style 'bg=colour8,fg=colour15'
          set    -g window-status-current-format ' #W#{?window_zoomed_flag,+z,} '
          set    -g window-status-last-style 'fg=colour14'
          set    -g window-status-style 'fg=colour10'
          set    -g window-status-format ' #W#{?window_zoomed_flag,+z,} '
          set -g status-right ""
          set -ga status-right \
              "#{?TMUX_TIMER,⏲ #{TMUX_TIMER} ,}"
          set    -ga status-right "$BR_TMUX_PROMPT_RIGHT"
          set    -ga status-right '#{?session_many_attached,x#{session_attached} ,}'
          set    -ga status-right \
              '#{?session_grouped,#{session_group_attached}/#{session_group_size} ,}'
          set    -ga status-right '#H'
          set    -g status-right-length 50
          set    -g window-status-activity-style 'italics'
          set    -g window-status-bell-style 'reverse'
          set    -g popup-style 'bg=colour0'
          set    -g popup-border-lines none

          # BINDINGS
          set -s -g escape-time 10
          set -w -g mode-keys vi
          set    -g status-keys vi

          # Select session in tree view.
          bind s run 'tmux-choose-session'

          # TODO incorporate into fzf interface
          # Create new session in-group.
          # bind g run 'tmux switch -t "$(tmux new-session -Pdt "#{session_name}")"'

          # Focus panes.
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          # Resize panes.
          bind C-h resize-pane -L 5
          bind C-j resize-pane -D 5
          bind C-k resize-pane -U 5
          bind C-l resize-pane -R 5

          # Move (swap) panes.
          bind M-h swap-pane -s '{left-of}'
          bind M-j swap-pane -s '{down-of}'
          bind M-k swap-pane -s '{up-of}'
          bind M-l swap-pane -s '{right-of}'

          # Go last window.
          bind P last-window

          # Quick sessions.
          bind T run-shell "gomux"
          bind N run-shell "gomux ~/store/notes"
          bind F run-shell "gomux ~/store/private-forest"
          bind M run-shell "tmuxinator monitor"

          # Reload config.
          bind R source-file ~/.tmux.conf

          # time popup
          bind t popup -w 64 -h 10 -k "date '+%H:%M:%S' && ${pkgs.util-linux}/bin/cal -3m"
        '';

      };
    };
}
