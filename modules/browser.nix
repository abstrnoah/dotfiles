{
  flake.modules.brumal.browser =
    {
      config,
      packages,
      library,
      lib,
      mkCases,
      ...
    }:

    # Some workarounds I seem to need on my Debian machine.
    # (1) QT_XCB_GL_INTEGRATION is a workaround from a while back, idk see commit
    # logs.
    # (2) ALSA_PLUGIN_DIR makes audio work under nix.
    # (3) QT_QUICK_BACKEND is a workaround for Qt6 issue where qutebrowser UI is
    # literally nonexistent. Unfortunately, this probably comes at a performance
    # cost.

    let
      rc = library.storeLegacyDotfiles "qutebrowser";
      config-py = "${rc}/home/me/.config/qutebrowser/config.py";
      qb-debian = packages.qutebrowser.overrideAttrs (prev: {
        preFixup =
          let
            alsaPluginDir = (lib.attrsets.getLib packages.alsa-plugins) + "/lib/alsa-lib";
          in
          prev.preFixup
          + ''
            makeWrapperArgs+=(
              --set QT_XCB_GL_INTEGRATION none
              --set ALSA_PLUGIN_DIR "${alsaPluginDir}"
              --set QT_QUICK_BACKEND software
              )
          '';
      });
      qutebrowser-t = library.writeShellApplication {
        name = "qutebrowser-t";
        runtimeInputs = [ config.userPackages.qutebrowser ];
        text = ''qutebrowser --temp-basedir --config-py ${config-py} "$@"'';
      };

    in
    {
      legacyDotfiles.qutebrowser = rc;

      userPackages = mkCases config.distro {
        "*" = {
          inherit (packages)
            firefox
            tor-browser-bundle-bin
            ;
          inherit qutebrowser-t;
        };
        debian.qutebrowser = qb-debian;
        nixos.qutebrowser = packages.qutebrowser;
      };
    };
}
