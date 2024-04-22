config@{ escapeShellArg, writeShellApplication, symlinkJoin, machine, ... }:
packages@{ xrandr, feh, wallpapers, ... }:

let
  xrandr-switch-output = name: active: inactive:
    writeShellApplication {
      name = "xrandr-switch-${name}";
      runtimeInputs = [ xrandr feh ];
      text = ''
        xrandr \
          --output ${escapeShellArg active} \
          --auto --primary \
          --output ${escapeShellArg inactive} --off \
          --dpi 100
        feh --bg-fill ${wallpapers}/home/me/.wallpaper
      '';
    };
  builtin = machine.xrandr-outputs.builtin;
  external = machine.xrandr-outputs.external;
in symlinkJoin {
  name = "xrandr-switch";
  paths = [
    (xrandr-switch-output "builtin" builtin external)
    (xrandr-switch-output "external" external builtin)
  ];
}
