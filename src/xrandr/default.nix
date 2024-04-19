config@{ self, machine, ... }:
packages@{ xrandr, feh, wallpapers, ... }:

let
  xrandr-switch-output = name: active: inactive:
    self.our-nixpkgs.writeShellApplication {
      name = "xrandr-switch-${name}";
      runtimeInputs = [ xrandr feh ];
      text = ''
        xrandr \
          --output ${self.our-nixpkgs.lib.escapeShellArg active} \
          --auto --primary \
          --output ${self.our-nixpkgs.lib.escapeShellArg inactive} --off \
          --dpi 100
        feh --bg-fill ${wallpapers}/home/me/.wallpaper
      '';
    };
  builtin = machine.xrandr-outputs.builtin;
  external = machine.xrandr-outputs.external;
in self.our-nixpkgs.symlinkJoin {
  name = "xrandr-switch";
  paths = [
    (xrandr-switch-output "builtin" builtin external)
    (xrandr-switch-output "external" external builtin)
  ];
}
