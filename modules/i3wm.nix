{
  flake.modules.nixos.wm =
    {
      library,
      config,
      utilities,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        concatStringsSep
        mapAttrsToList
        mapAttrs
        mkMerge
        mkIf
        mkDefault
        mkCases
        ;

      inherit (utilities)
        writeTextFile
        ;

      cfg = config.brumal.cfg.i3wm;

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

    in
    {

      options.brumal.cfg.i3wm = {
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

      config = mkCases config.brumal.distro {

        "*".brumal.cfg.i3wm = {

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

        "*".brumal.rcs.i3wm = writeTextFile {
          name = "i3wm-rc";
          destination = "${config.brumal.env.XDG_CONFIG_HOME}/i3/config";
          text = config.brumal.cfg.i3wm.body.text;
        };

        nixos = {
          services.xserver.windowManager.i3.enable = true;
          services.xserver.windowManager.i3.package = config.brumal.packages.i3wm;
          services.xserver.windowManager.i3.extraPackages = [
            config.brumal.packages.i3status
            config.brumal.packages.i3lock
            config.brumal.packages.rofi
          ];
        };

      };

    };
}
