top@{config, ...}: {
  flake.modules.brumal.wm =
    {
      packages,
      library,
      lib,
      ...
    }:
    {
      imports = builtins.attrValues {
        inherit (top.config.flake.modules.brumal)
          dunst
          rofi;
      };

      legacyDotfiles = {
        i3wm = library.storeLegacyDotfiles "i3wm";
        xsession = library.writeTextFile {
          name = "xsession";
          text = ''exec "${packages.i3wm}/bin/i3"'';
          destination = "/home/me/.xsession";
        };
      };

      userPackages = {
        inherit (packages)
          i3wm
          i3status
          libnotify
          # wallpapers TODO
          wmctrl
          xrandr-invert-colors
          xbacklight
          ;
      };
    };
}
