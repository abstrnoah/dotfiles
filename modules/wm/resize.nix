{
  flake.nixosModules.gui =
    { config, ... }:
    let
      cfg = config.brumal.i3wm;
      k = cfg.keys;
      dims = cfg.dimstrs;
    in
    {
      brumal.i3wm.body.modes.resize = {
        key = "r";
        block.body.bindsym = {
          h = "resize shrink width ${dims.resize_sm} px or ${dims.resize_sm} ppt";
          j = "resize grow height ${dims.resize_sm} px or ${dims.resize_sm} ppt";
          k = "resize shrink height ${dims.resize_sm} px or ${dims.resize_sm} ppt";
          l = "resize grow width ${dims.resize_sm} px or ${dims.resize_sm} ppt";
        };
      };
    };
}
