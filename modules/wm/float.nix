{
  flake.nixosModules.gui =
    { config, ... }:
    let
      cfg = config.brumal.i3wm;
      k = cfg.keys;
    in
    {
      # Use Mouse+$mod to drag floating windows to their wanted position
      brumal.i3wm.body.directives = [ ''floating_modifier ${k.mod}'' ];
      brumal.i3wm.body.bindsym."${k.shift}+space" = "floating toggle";
      brumal.i3wm.body.bindsym.space = "focus mode_toggle";
    };
}
