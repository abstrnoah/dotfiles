{
  flake.nixosModules.gui =
    { config, pkgs, ... }:
    {
      brumal.i3wm.body.bindsym.${config.brumal.i3wm.keys.enter} = "exec i3-sensible-terminal";
    };
}
