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
      pkg = pkgs.qutebrowser;
      pkg-t = pkgs.qutebrowser-t;
      env = config.brumal.env;
      py-path = "${env.XDG_CONFIG_HOME}/qutebrowser/config.py";
      rc = storeLegacyDotfiles "qutebrowser";
      rc-py = "${rc}/${py-path}";
    in
    {
      brumal.profile.packages = [
        pkg
        pkg-t
        rc
      ];
      nixpkgs.overlays = [
        (final: prev: {
          qutebrowser-t = writeShellApplication {
            name = "qutebrowser-t";
            runtimeInputs = [ final.qutebrowser ];
            text = ''
              qutebrowser --temp-basedir --config-py ${rc-py} "$@"
            '';
          };
        })
      ];
    };
}
