config@{ bundle, store-dotfiles, get-lib-output, write-shell-app }:
packages@{ qutebrowser, alsa-plugins }:

# Some workarounds I seem to need on my Debian machine.
# (1) QT_XCB_GL_INTEGRATION is a workaround from a while back, idk see commit
# logs.
# (2) ALSA_PLUGIN_DIR makes audio work under nix.
# (3) QT_QUICK_BACKEND is a workaround for Qt6 issue where qutebrowser UI is
# literally nonexistent. Unfortunately, this probably comes at a performance
# cost.

let
  rc = store-dotfiles "qutebrowser";
  config-py = "${rc}/home/me/.config/qutebrowser/config.py";
  this-qutebrowser = qutebrowser.overrideAttrs (prev: {
    preFixup =
      let alsaPluginDir = (get-lib-output alsa-plugins) + "/lib/alsa-lib";
      in prev.preFixup + ''
        makeWrapperArgs+=(
          --set QT_XCB_GL_INTEGRATION none
          --set ALSA_PLUGIN_DIR "${alsaPluginDir}"
          --set QT_QUICK_BACKEND software
          )
      '';
  });
in
bundle {
  name = "qutebrowser";
  packages = {
    qutebrowser = this-qutebrowser;
    qutebrowser-t = write-shell-app {
      name = "qutebrowser-t";
      runtimeInputs = [ this-qutebrowser ];
      text = ''
        qutebrowser --temp-basedir --config-py ${config-py} "$@"
      '';
    };
    qutebrowser-rc = rc;
  };
}
