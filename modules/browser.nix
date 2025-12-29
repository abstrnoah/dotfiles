{
  flake.nixosModules.gui =
    {
      config,
      pkgs,
      utilities,
      ...
    }:
    let
      inherit (utilities) storeLegacyDotfiles writeShellApplication;
      qb = pkgs.qutebrowser;
      qb-t = pkgs.qutebrowser-t;
      env = config.brumal.env;
      py-path = "${env.XDG_CONFIG_HOME}/qutebrowser/config.py";
      qbrc = storeLegacyDotfiles "qutebrowser";
      qbrc-py = "${qbrc}/${py-path}";
    in
    {
      # TODO This is an example where it really doesn't make sense to separate profile packages from system-wide packages because below I'm setting mime defaults system-wide.
      brumal.profile.packages = [
        qb
        qb-t
        qbrc
        pkgs.firefox
        pkgs.ungoogled-chromium
      ];
      # Overlay within nixos because contains my rc.
      nixpkgs.overlays = [
        (final: prev: {
          qutebrowser-t = writeShellApplication {
            name = "qutebrowser-t";
            runtimeInputs = [ final.qutebrowser ];
            text = ''
              qutebrowser --temp-basedir --config-py ${qbrc-py} "$@"
            '';
          };
        })
      ];
      xdg.mime.defaultApplications = {
        "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
        "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      };
    };
}
