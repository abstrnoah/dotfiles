config@{ escape-shell-arg, write-shell-app, symlink-join, machine }:
packages@{ xrandr, feh, wallpapers }:

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
  xrandr-switch-primary-left = name: primary: secondary:
    write-shell-app {
      name = "xrandr-switch-${name}";
      runtimeInputs = [ xrandr feh ];
      text = ''
        xrandr \
          --output ${escape-shell-arg primary} \
          --auto --primary \
          --output ${escape-shell-arg secondary} --auto --right-of ${escape-shell-arg primary} \
          --dpi 100
        feh --bg-fill ${wallpapers}/home/me/.wallpaper
      '';
    };
  xrandr-switch-primary-right = name: primary: secondary:
    write-shell-app {
      name = "xrandr-switch-${name}";
      runtimeInputs = [ xrandr feh ];
      text = ''
        xrandr \
          --output ${escape-shell-arg primary} \
          --auto --primary \
          --output ${escape-shell-arg secondary} --auto --left-of ${escape-shell-arg primary} \
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
    (xrandr-switch-primary-right "builtin-external" external builtin)
    (xrandr-switch-primary-left "external-builtin" external builtin)
  ];
}
