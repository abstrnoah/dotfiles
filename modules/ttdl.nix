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
    };
}
