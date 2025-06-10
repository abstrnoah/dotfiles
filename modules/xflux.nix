{
  flake.modules.brumal.xflux =
    {
      library,
      packages,
      ...
    }:
    {
      userPackages = {
        inherit (packages) xflux;
        auto-xflux = library.writeShellApplication {
          name = "auto-xflux";
          runtimeInputs = [
            packages.procps
            packages.curl
            packages.findutils
            packages.jq
          ];
          text = ''
            # shellcheck disable=SC2016
            pgrep -c ^xflux$ \
            || curl -s ipinfo.io | jq -j ".loc" \
               | xargs -d, /bin/sh -c 'xflux -l $1 -g $2' sh
          '';
        };
      };
    };
}
