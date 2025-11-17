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
      ];
      environment.systemPackages = [
        pkgs.htop
      ];
    }
  );
}
