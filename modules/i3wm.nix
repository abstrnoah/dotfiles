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
      inherit (library)
        mkOption
        types
        concatStringsSep
        mapAttrsToList
        mkMerge
        mkIf
        mkDefault
        ;
      inherit (utilities)
        writeTextFile
        ;

      cfg = config.brumal.programs.i3wm;
      env = config.brumal.env;

      i3wmBodyModule =
        { config, ... }:
        {
          options = {
            variables = mkOption {
              type = types.attrsOf types.str;
              default = { };
            };
            directives = mkOption { type = types.listOf types.str; };
            blocks = mkOption {
              type = types.attrsOf (types.submodule i3wmBlockModule);
              default = { };
            };
            modes = mkOption {
              type = types.attrsOf (types.submodule i3wmModeModule);
              default = { };
            };
            text = mkOption { type = types.str; };
          };
          config = {
            text =
              let
                setDirectivesText = concatStringsSep "\n" (
                  # TODO Properly escape value
                  mapAttrsToList (name: value: "set \$${name} \"${value}\"") config.variables
                );
                directivesText = concatStringsSep "\n" config.directives;
                blocksText = concatStringsSep "\n" (mapAttrsToList (_: block: block.text) config.blocks);
                modesText = concatStringsSep "\n" (mapAttrsToList (_: mode: mode.text) config.modes);
              in
              ''
                ${setDirectivesText}
                ${directivesText}
                ${blocksText}
                ${modesText}
              '';
          };
        };

      i3wmBlockModule =
        { name, config, ... }:
        {
          options = {
            head = mkOption {
              type = types.str;
              default = name;
            };
            body = mkOption { type = types.submodule i3wmBodyModule; };
            text = mkOption { type = types.str; };
          };
          config = {
            text = ''
              ${config.head} {
                ${config.body.text}
              }
            '';
          };
        };

      i3wmModeModule =
        {
          name,
          config,
          options,
          ...
        }:
        {
          options = {
            block = mkOption { type = types.submodule i3wmBodyModule; };
            tips = mkOption { type = types.str; };
            address = mkOption { type = types.str; };
            key = mkOption { type = types.str; };
            text = mkOption { type = types.str; };
          };
          config = {
            address = mkMerge [
              (mkIf options.tips.isDefined "${name}: ${config.tips}")
              (mkDefault name)
            ];
            # TODO Escape address
            block.head = "mode \"${config.address}\"";
            block.body.directives = [
              # TODO factor out keys?
              ''bindsym Escape mode "default"''
              ''bindsym ctrl+bracketleft mode "default"''
            ];
            text = ''
              bindsym ${config.key} mode ${config.address}
              ${config.block.text}
            '';
          };
        };

      opts = {
        keys = mkOption {
          type = types.attrsOf types.str;
          default = { };
        };
        dimensions = mkOption {
          type = types.attrsOf types.numbers.nonnegative;
          default = { };
        };
        brightness_interval = mkOption { type = types.numbers.positive; };
        body = mkOption { type = types.submodule i3wmBodyModule; };
      };

      i3wmRcP = writeTextFile {
        name = "i3wm-rc";
        destination = "${env.XDG_CONFIG_HOME}/i3/config";
        text = cfg.body.text;
      };

    in
    {

      options.brumal.programs.i3wm = opts;

      config.brumal.programs.i3wm = {

        keys = {
          escringe = "Escape";
          esc = "ctrl+bracketleft";
          ctrl = "ctrl";
          alt = "Mod1";
          super = "Mod4";
          shift = "shift";
          enter = "Return";
          colon = "shift+semicolon";
          percent = "shift+5";
          pipe = "shift+backslash";
          minus = "minus";
          plus = "equal";
          underscore = "shift+minus";
          grave = "grave";
          tilde = "shift+grave";
          singlequote = "apostrophe";
          mod = config.keys.super;
        };
        dimensions = {
          default_border = 1;
          base_gap_inner = 7;
          base_gap_outer = 0;
        };
        brightness_interval = 5;

        body = {
          directives = [
            ''for_window [class=".*"] border pixel ${builtins.toString cfg.dimensions.default_border}''
            ''gaps inner ${builtins.toString cfg.dimensions.base_gap_inner}''
            ''border_radius 2''
          ];
        };

      };

      config.brumal.profile.packages = [ i3wmRcP ];

      config.services.xserver.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-rounded;
        extraPackages = [
          pkgs.i3status
          pkgs.i3lock
          pkgs.rofi
        ];
      };

    };
}
