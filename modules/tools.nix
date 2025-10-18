{
}:
{
  flake.nixosModules.base = moduleWithSystem (
    perSystem@{ inputs' }:
    { ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          emplacetree = inputs'.emplacetree.packages.emplacetree;
        })
      ];
    }
  );
}
