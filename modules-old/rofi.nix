{
  flake.modules.brumal.rofi =
    { library, packages, ... }:
    {
      legacyDotfiles.rofi = library.storeLegacyDotfiles "rofi";
      userPackages.rofi = packages.rofi.override { symlink-dmenu = true; };
    };
}
