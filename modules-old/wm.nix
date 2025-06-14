top@{ config, inputs, ... }:
{
  flake.modules.brumal.wm =
    {
      system,
      packages,
      library,
      lib,
      ...
    }:
    {
      imports = builtins.attrValues {
        inherit (top.config.flake.modules.brumal)
          dunst
          rofi
          ;
      };

      legacyDotfiles = {
        i3wm = library.storeLegacyDotfiles "i3wm";
        xsession = library.writeTextFile {
          name = "xsession";
          text = ''exec "${packages.i3wm}/bin/i3"'';
          destination = "/home/me/.xsession";
        };

        # TODO Replace with direct string interpolation of feh and i3lock commands.
        wallpapers = library.storeSymlinks {
          name = "wallpapers";
          mapping = [
            {
              source = inputs.wallpapers.packages.${system}.pixel-city-at-night-png;
              destination = "/home/me/.wallpaper";
            }
            {
              source = inputs.wallpapers.packages.${system}.solarized-stars-png;
              destination = "/home/me/.wallpaperlock";
            }
          ];
        };

      };

      userPackages = {
        inherit (packages)
          i3wm
          i3status
          # i3lock # TODO per distro address debian pam issue
          libnotify
          # wallpapers TODO
          wmctrl
          xrandr-invert-colors
          xbacklight
          ;
      };
    };
}
