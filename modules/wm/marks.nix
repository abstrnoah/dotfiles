{
  flake.nixosModules.gui =
    { config, ... }:
    let
      cfg = config.brumal.i3wm;
      k = cfg.keys;
    in
    {
      brumal.i3wm = {
        body.directives = [ ''show_marks no'' ];
        body.bindsym = {
          m = "exec i3-input -F 'mark --add %s' -l 1 -P 'mark: '";
          ${k.singlequote} = "exec i3-input -F '[con_mark=\"^%s$\"] focus' -l 1 -P 'goto: '";
          "${k.shift}+m" = "unmark";
        };
      };
    };
}
