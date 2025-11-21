{
  flake.nixosModules.gui =
    {
      config,
      library,
      utilities,
      pkgs,
      ...
    }:
    let

      inherit (library) mapAttrs;
      inherit (utilities) writeShellApplication;
      cfg = config.brumal.i3wm;
      k = cfg.keys;
      env = config.brumal.env;
      dims = library.mapAttrs (_: builtins.toString) cfg.dimensions;
      i3 = config.services.xserver.windowManager.i3.package;

      with-rofi-ws-script = writeShellApplication {
        name = "with-rofi-ws";
        runtimeInputs = [
          i3
          pkgs.rofi
          pkgs.jq
        ];
        text = ''
          gen_workspaces() {
              i3-msg -t get_workspaces | tr ',' '\n' | grep "name" | sed 's/"name":"\(.*\)"/\1/g' | sort -n
          }

          jq_query=$(cat <<'EOF'
          # Compute last consecutive number in list, plus one.
          def first_missing: . as [$first, $second]
              | if ($first + 1 == $second)
                  then (.[1:] | first_missing)
                  else ($first + 1)
                  end;
          # Max with 0 so that ws num will always be non-negative.
          # Merge [-1] so that we start looking for numbers at zero.
          map(.num) + [-1] | unique | first_missing | [., 0] | max
          EOF
          )

          empty_ws() {
            i3-msg -t get_workspaces | jq "$jq_query"
          }

          WORKSPACE=$( (echo "-"; gen_workspaces)  | rofi -dmenu -p "$1")
          shift

          if [ "-" = "$WORKSPACE" ]
          then
              WORKSPACE=$(empty_ws)
          fi
          if [ -n "$WORKSPACE" ]
          then
              "$@" "$WORKSPACE"
          fi
        '';
      };
      with-rofi-ws-bin = "${with-rofi-ws-script}/bin/with-rofi-ws";

    in
    {

      services.xserver.windowManager.i3.extraPackages = [ pkgs.rofi ];

      brumal.i3wm.body.bindsym = {

        # Run
        ${k.colon} = "exec rofi -show run";

        # File browser
        slash = "exec rofi -show filebrowser";

        # Go to window
        d = "exec rofi -show window";

        # Change workspace
        n = "workspace next_on_output";
        p = "workspace prev_on_output";
        comma = "workspace back_and_forth";
        "${k.alt}+r" = "exec i3-input -F 'rename workspace to \"%s\"' -P 'rename ws: '";
        g = ''exec ${with-rofi-ws-bin} "go to" i3-msg workspace'';
        "${k.alt}+d" = ''exec ${with-rofi-ws-bin} "move to" i3-msg "move window to workspace"'';

        # Change focus
        h = "focus left";
        j = "focus down";
        k = "focus up";
        l = "focus right";

        # Move focused window
        "${k.alt}+h" = "move left";
        "${k.alt}+j" = "move down";
        "${k.alt}+k" = "move up";
        "${k.alt}+l" = "move right";

        # Split with vim-like mneumonics
        v = "split h";
        s = "split v";

        # Change container layout
        t = "layout toggle tabbed stacking";
        e = "layout toggle splitv splith";

        # Fullscreen focused container
        f = "fullscreen toggle";

        # Kill focused window
        "${k.shift}+q" = "kill";

      };

    };
}
