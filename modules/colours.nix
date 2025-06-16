{
  flake.modules.nixos.base =
    { library, options, ... }:
    let
      inherit (library)
        mkOption
        types
        ;
    in
    {

      options = {
        brumal.colours = mkOption {
          type = types.attrsOf (types.strMatching "[[:xdigit:]]{6}");
          default = [ ];
        };
      };

      # Solarized
      config.brumal.colours = {
        base03 = "002b36";
        base02 = "073642";
        base01 = "586e75";
        base00 = "657b83";
        base0 = "839496";
        base1 = "93a1a1";
        base2 = "eee8d5";
        base3 = "fdf6e3";
        yellow = "b58900";
        orange = "cb4b16";
        red = "dc322f";
        magenta = "d33682";
        violet = "6c71c4";
        blue = "268bd2";
        cyan = "2aa198";
        green = "859900";
      };
    };

  flake.modules.nixos.wm =
    { config, ... }:
    {

      brumal.cfg.i3wm.body.directives = with config.brumal.colours; [
        ''
          #class                  border    bg        text      indicator  child_border
          client.focused          ${base03} ${base02} ${base1}  ${green}   ${yellow}
          client.focused_inactive ${base03} ${base03} ${base01} ${base01}  ${base03}
          client.unfocused        ${base03} ${base03} ${base01} ${base01}  ${base03}
        ''
      ];

      brumal.cfg.i3wm.body.blocks.bar.body.blocks.colors.body.directives = with config.brumal.colours; [
        "background ${base03}"
        "statusline ${base3}"
        "separator  ${base00}"

        ''
          #class border bg text
          focused_workspace  ${base0}  ${base03} ${base3}
          active_workspace   ${base02} ${base03} ${base3}
          inactive_workspace ${base02} ${base03} ${base0}
          urgent_workspace   ${orange} ${base03} ${orange}
          binding_mode       ${base02} ${base03} ${green}
        ''
      ];
    };

}
