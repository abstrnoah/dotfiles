{
  flake.nixosModules.base =
    { pkgs, utilities, ... }:
    let
      inherit (utilities) storeLegacyDotfiles;
      rc = storeLegacyDotfiles "ttdl";
    in
    {
      brumal.profile.packages = [
        pkgs.ttdl
        rc
      ];
      brumal.files.bin = {
        ttdl-all.text = ''${pkgs.ttdl}/bin/ttdl list --all --completed none "$@"'';
        ttdl-now.text = ''ttdl list --pri x+ "$@"'';
        ttdl-unsorted.text = ''ttdl-all --pri none "$@"'';
      };
    };
}
