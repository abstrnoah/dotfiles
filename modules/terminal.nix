{
  flake.nixosModules.gui =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.kitty ];
      environment.variables.TERMINAL = "kitty";
      brumal.i3wm.body.bindsym.${config.brumal.i3wm.keys.enter} = "exec i3-sensible-terminal";
    };
}
