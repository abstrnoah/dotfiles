{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.import-tree.url = "github:vic/import-tree";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.emplacetree.url = "github:abstrnoah/emplacetree";
  inputs.emplacetree.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    inputs@{
      flake-parts,
      import-tree,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);
}
