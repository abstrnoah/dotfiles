config@{ escape-shell-arg, write-shell-app, symlink-join, machine, ... }:
packages@{ xrandr, feh, wallpapers, ... }:

let
  xrandr-switch-output = name: active: inactive:
    write-shell-app {
      name = "xrandr-switch-${name}";
      runtimeInputs = [ xrandr feh ];
      text = ''
        xrandr \
          --output ${escape-shell-arg active} \
          --auto --primary \
          --output ${escape-shell-arg inactive} --off \
          --dpi 100
        feh --bg-fill ${wallpapers}/home/me/.wallpaper
      '';
    };
  builtin = machine.xrandr-outputs.builtin;
  external = machine.xrandr-outputs.external;
in symlink-join {
  name = "xrandr-switch";
  paths = [
    (xrandr-switch-output "builtin" builtin external)
    (xrandr-switch-output "external" external builtin)
  ];
}
