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
        pkgs.jabref
        pkgs.fd
        pkgs.discord
        pkgs.tectonic
        pkgs.tree
        pkgs.uni
      ];
      brumal.nixpkgs.allowUnfree = [
        "discord"
      ];
      environment.systemPackages = [
        pkgs.htop
      ];
    }
  );
}
