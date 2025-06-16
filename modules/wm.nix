# TODO Multi-user wm setup??
# This is for general declaration and setup for wm. See `i3wm-config.nix` for actual i3wm config.
{

  flake.modules.nixos.wm =
    { config, library, utilities, ... }:
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
        ;

      inherit (utilities)
        writeTextFile
        ;

      i3wmBodyModule =
        { config, ... }:
        {
          options = {
            variables = mkOption {
              type = types.attrsOf types.str;
              default = { };
            };
            directives = mkOption { type = types.listOf types.str; };
            blocks = mkOption { type = types.attrsOf (types.submodule i3wmBlockModule); default = {};};
            modes = mkOption { type = types.attrsOf (types.submodule i3wmModeModule);default = {}; };
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
              in
              ''
                ${setDirectivesText}
                ${directivesText}
                ${blocksText}
              '';
            blocks = mapAttrs (_: mode: mode.block) config.modes;
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
          };
          config = {
            address = mkMerge [
              (mkIf options.tips.isDefined "${name}: ${config.tips}")
              (mkDefault name)
            ];
            # TODO Escape address
            block.head = "mode \"${config.address}\"";
            block.body.directives = [
              ''bindsym Escape mode "default"''
              ''bindsym ctrl+bracketleft mode "default"''
            ];
          };
        };

    in
    {

      options.brumal.cfg.i3wm = mkOption { type = types.submodule i3wmBodyModule; };

      config = library.mkCases config.brumal.distro {
        nixos = {

          services.xserver.enable = true;

          services.xserver.displayManager.gdm.enable = true; # TODO

          services.xserver.windowManager.i3.enable = true;
          services.xserver.windowManager.i3.package = config.brumal.packages.i3wm;
          services.xserver.windowManager.i3.extraPackages = [
            config.brumal.packages.i3status
            config.brumal.packages.i3lock
            config.brumal.packages.rofi
          ];
          brumal.rcs.i3wm = writeTextFile {
            name = "i3wm-rc";
            destination = "${config.brumal.env.XDG_CONFIG_HOME}/.config";
            text = config.brumal.cfg.i3wm.text;
          };

        };
      };

    };

}
