{
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.base = moduleWithSystem (
    perSystem@{ inputs' }:
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          emplacetree = inputs'.emplacetree.packages.emplacetree;
        })
      ];
      brumal.profile.packages = [
        pkgs.emplacetree
        pkgs.bat
        pkgs.bat-extras.batdiff
        pkgs.bat-extras.batman
        pkgs.bat-extras.batwatch
        pkgs.silver-searcher
        pkgs.nnn
        pkgs.zathura # TODO config
        pkgs.fd
        pkgs.tectonic
        pkgs.tree
        pkgs.uni
        pkgs.curl # TODO config
        pkgs.zip
        pkgs.unzip
        pkgs.numbat
        pkgs.jq
        pkgs.lsof
        # TODO FIXME Packages held back because they break on current nixpkgs
        inputs'.nixpkgs-heldback.legacyPackages.jabref # TODO config
      ];
      environment.systemPackages = [
        pkgs.htop
      ];
    }
  );
}
