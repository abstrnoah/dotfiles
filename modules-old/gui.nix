top@{ config, ... }:
{
  flake.modules.brumal.gui =
    {
      packages,
      library,
      mkCases,
      config,
      ...
    }:
    {
      imports = builtins.attrValues {
        inherit (top.config.flake.modules.brumal)
          browser
          udiskie
          xflux
          zathura
          ;
      };

      userPackages = mkCases config.distro {
        "*" = {
          inherit (packages)
            signal-desktop
            spotify
            spotify-cli-linux
            discord
            xclip
            xournalpp
            jabref
            feh
            mononoki
            zbar
            ;
        };

        # TODO Telegram seems to pull in systemctl into bin which is bad for debian
        nixos = { inherit (packages) telegram; };
      };
    };
}
