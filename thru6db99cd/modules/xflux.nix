{
  flake.modules.nixos.wm =
    { packages, utilities, ... }:
    {
      brumal.cfg.i3wm.body.directives = [ "exec_always ${packages.auto-xflux}" ];
      brumal.packages.auto-xflux = utilities.writeShellApplication {
        name = "auto-xflux";
        runtimeInputs = [
          packages.procps
          packages.curl
          packages.findutils
          packages.jq
          packages.xflux
        ];
        text = ''
          # shellcheck disable=SC2016
          pgrep -c ^xflux$ \
          || curl -s ipinfo.io | jq -j ".loc" \
             | xargs -d, /bin/sh -c 'xflux -l $1 -g $2' sh
        '';
      };
    };
}
