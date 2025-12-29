{
  flake.nixosModules.brumal-wm =
    {
      config,
      library,
      utilities,
      pkgs,
      options,
      ...
    }:
    let
      inherit (library)
        mkOption
        types
        concatStringsSep
        mapAttrs'
        nameValuePair
        mapAttrsToList
        mkMerge
        mkIf
        mkDefault
        ;

      cfg = config.brumal.i3wm;
      k = cfg.keys;
      env = config.brumal.env;
      i3wmP = config.services.xserver.windowManager.i3.package;

      i3wmBodyModule =
        { options, config, ... }:
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
            leader = mkOption { type = types.str; };
            # TODO handle --release
            bindsym = mkOption {
              type = types.attrsOf types.str;
              default = { };
            };
            text = mkOption { type = types.str; };
          };
          config = {
            bindsym = mapAttrs' (name: value: nameValuePair value.key ''mode ${value.address}'') config.modes;
            directives =
              let
                execDs = map (x: ''exec ${x}'') config.exec;
                execAlwaysDs = map (x: ''exec_always ${x}'') config.exec_always;
                makeKey = if options.leader.isDefined then (key: "${config.leader}+${key}") else (key: key);
                bindsymDs = mapAttrsToList (key: cmd: ''bindsym ${makeKey key} ${cmd}'') config.bindsym;
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
            block.body.bindsym = {
              ${k.escringe} = " mode default";
              ${k.esc} = "mode default";
            };
            text = config.block.text;
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
        dimstrs = mkOption {
          type = types.attrsOf types.str;
        };
        brightness_interval = mkOption { type = types.numbers.positive; }; # TODO maybe shouldn't be here
        font = mkOption { type = types.str; };
        body = mkOption { type = types.submodule i3wmBodyModule; };
      };

    in
    {

      options.brumal.i3wm = opts;

      config.brumal.i3wm.body.directives = mkIf options.brumal.i3wm.font.isDefined [
        ''font ${cfg.font}''
      ];

      config.brumal.i3wm.dimstrs = library.mapAttrs (_: builtins.toString) cfg.dimensions;

      config.services.xserver.windowManager.i3.enable = true;

      config.brumal.profile.postSwitch = [
        ''${i3wmP}/bin/i3-msg reload || echo "Warning: i3 not reloadable"''
      ];

      config.brumal.files.xdgConfig."i3/config".text = ''
        # i3 config file (v4)
        ${cfg.body.text}
      '';

    };
}
