{
  inputs,
  moduleWithSystem,
  ...
}:
{
  perSystem =
    { inputs', ... }:
    {
      overlayAttrs = {
        emplacetree = inputs'.emplacetree.packages.default;
        brumalwiki = inputs'.brumalwiki.packages.default;
      };
    };

  flake.nixosModules.base = moduleWithSystem (
    perSystem@{ inputs' }:
    { pkgs, ... }:
    {
      brumal.profile.packages = [
        pkgs.emplacetree
        pkgs.bat
        pkgs.bat-extras.batdiff
        pkgs.bat-extras.batman
        pkgs.bat-extras.batwatch
        pkgs.silver-searcher
        pkgs.nnn
        pkgs.fd
        pkgs.tectonic
        pkgs.tree
        pkgs.uni
        pkgs.zip
        pkgs.unzip
        pkgs.numbat
        pkgs.num-utils
        pkgs.jq
        pkgs.yq-go
        pkgs.lsof
        pkgs.hydra-check
        pkgs.feh
        pkgs.timer
        pkgs.pandoc
        pkgs.brumalwiki
        # TODO FIXME Packages held back because they break on current nixpkgs
        inputs'.nixpkgs-heldback.legacyPackages.jabref # TODO config
      ];
      environment.systemPackages = [
        pkgs.htop
      ];
    }
  );
}
