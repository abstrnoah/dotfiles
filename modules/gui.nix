top@{ config, ... }:
{
  flake.modules.brumal.gui =
    { packages, library, ... }:
    {
      imports = builtins.attrValues {
        inherit (top.config.flake.modules.brumal)
          browser
          udiskie
          xflux
          zathura
          ;
      };

      userPackages = {
        inherit (packages)
          signal-desktop
          spotify
          spotify-cli-linux
          telegram
          discord
          xclip
          xournalpp
          jabref
          feh
          mononoki
          zbar
          ;
      };
    };
}
