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
        pkgs.jabref # TODO config
        pkgs.fd
        pkgs.discord
        pkgs.signal-desktop
        pkgs.tectonic
        pkgs.tree
        pkgs.uni
        pkgs.curl # TODO config
        pkgs.zip
        pkgs.unzip
        pkgs.numbat
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
