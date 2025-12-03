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
      brumal.profile.packages = [
        qb
        qb-t
        qbrc
        pkgs.firefox
      ];
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
    };
}
