{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.import-tree.url = "github:vic/import-tree";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-heldback.url = "github:NixOS/nixpkgs/nixos-25.11";

  inputs.emplacetree.url = "github:abstrnoah/emplacetree";
  inputs.emplacetree.inputs.nixpkgs.follows = "nixpkgs";

  inputs.agenix.url = "github:ryantm/agenix";
  inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.agenix.inputs.darwin.follows = "";

  inputs.direnv-instant.url = "github:Mic92/direnv-instant";
  inputs.direnv-instant.inputs.nixpkgs.follows = "nixpkgs";
  inputs.direnv-instant.inputs.flake-parts.follows = "flake-parts";

  inputs.wallpapers.url = "github:abstrnoah/wallpapers";

  outputs =
    inputs@{
      flake-parts,
      import-tree,
      agenix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);
}
