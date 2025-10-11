{ moduleWithSystem, ... }:
{
  flake.modules.nixos.wm = moduleWithSystem (
    perSystem@{ inputs' }:
    { packages, ... }:
    let
      wallpaper = inputs'.wallpapers.packages.pixel-city-at-night-png;
    in
    {
      brumal.cfg.i3wm.body.directives = [
        "exec_always --no-startup-id ${packages.feh} --bg-fill ${wallpaper}"
      ];
    }
  );
}
