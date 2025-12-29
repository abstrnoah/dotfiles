{
  flake.nixosModules.brumal =
    {
      pkgs,
      utilities,
      library,
      config,
      ...
    }:
    let
      inherit (library)
        mkOption
        mkDefault
        types
        concatStringsSep
        mapAttrsToList
        mapAttrs
        collect
        isString
        escapeXML
        ;
      inherit (utilities)
        fileType
        ;
      cfg = config.brumal.i3status;
    in
    {
      options.brumal.i3status = {
        configFile = mkOption {
          type = fileType;
        };
        order = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        blocks = mkOption {
          type = types.attrsOf (types.attrsOf (types.attrsOf types.str));
          default = { };
        };
      };
      config.brumal.i3status.configFile.target = "i3status-config";
      config.brumal.i3status.configFile.text =
        let
          orderText = concatStringsSep "\n" (map (x: ''order += "${escapeXML x}"'') cfg.order);
          mkDirectiveText = key: value: ''${key} = "${escapeXML value}"'';
          mkBlockText = (
            kind: name: values: ''
              ${kind} ${escapeXML name} {
              ${concatStringsSep "\n" (mapAttrsToList mkDirectiveText values)}
              }
            ''
          );
          blocksText = concatStringsSep "\n" (
            collect isString (mapAttrs (kind: (mapAttrs (mkBlockText kind))) cfg.blocks)
          );
        in
        ''
          ${orderText}
          ${blocksText}
        '';
      config.brumal.i3wm.body.blocks.bar.body.directives = [
        "status_command ${pkgs.i3status}/bin/i3status --config ${cfg.configFile.source}"
      ];
    };
}
