{
  flake.nixosModules.brumal-wm =
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
      k = cfg.keys;
      env = config.brumal.env;

      i3wmBodyModule =
        { config, ... }:
        {
          options = {
            directives = mkOption { type = types.listOf types.str; };
            blocks = mkOption {
              type = types.attrsOf (types.submodule i3wmBlockModule);
              default = { };
            };
            modes = mkOption {
              type = types.attrsOf (types.submodule i3wmModeModule);
              default = { };
            };
            exec = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            exec_always = mkOption {
              type = types.listOf types.str;
              default = [ ];
            };
            bindsym = mkOption {
              type = types.attrsOf types.str;
              default = { };
            };
            text = mkOption { type = types.str; };
          };
          config = {
            directives =
              let
                execDs = map (x: ''exec ${x}'') config.exec;
                execAlwaysDs = map (x: ''exec_always ${x}'') config.exec_always;
                bindsymDs = mapAttrsToList (key: cmd: ''bindsym ${key} ${cmd}'') config.bindsym;
              in
              execDs ++ execAlwaysDs ++ bindsymDs;
            text =
              let
                directivesText = concatStringsSep "\n" config.directives;
                blocksText = concatStringsSep "\n" (mapAttrsToList (_: block: block.text) config.blocks);
                modesText = concatStringsSep "\n" (mapAttrsToList (_: mode: mode.text) config.modes);
              in
              ''
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
            block = mkOption { type = types.submodule i3wmBlockModule; };
            tips = mkOption { type = types.str; };
            address = mkOption {
              type = types.str;
              default = name;
            };
            key = mkOption { type = types.str; };
            text = mkOption { type = types.str; };
          };
          config = {
            address = mkIf options.tips.isDefined "${name}: ${config.tips}";
            # TODO Escape address
            block.head = "mode \"${config.address}\"";
            block.body.directives = [
              ''bindsym ${k.escringe} mode default''
              ''bindsym ${k.esc} mode default''
            ];
            # TODO This shortcircuits the parent-level bindsym option,
            # meaning bindsym does not actually represent the true key mapping table.
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
        brightness_interval = mkOption { type = types.numbers.positive; }; # TODO maybe shouldn't be here
        font = mkOption { type = types.str; };
        body = mkOption { type = types.submodule i3wmBodyModule; };
      };

      i3wmRcP = writeTextFile {
        name = "i3wm-rc";
        destination = "${env.XDG_CONFIG_HOME}/i3/config";
        text = ''
          # i3 config file (v4)
          ${cfg.body.text}
        '';
      };

    in
    {

      options.brumal.programs.i3wm = opts;

      config.brumal.programs.i3wm.body.directives = [
        ''font ${cfg.font}''
      ];

      config.services = {
        xserver.enable = true;
        displayManager.gdm.enable = true;
        xserver.windowManager.i3 = {
          enable = true;
        };
      };

      config.brumal.profile.packages = [ i3wmRcP ]; # TODO move to separate file

    };
}
