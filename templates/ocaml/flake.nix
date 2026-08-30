{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    brumalpkgs.url = "github:abstrnoah/brumalpkgs";
    brumalpkgs.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    opam-repository.url = "github:ocaml/opam-repository";
    opam-repository.flake = false;

    opam-nix.url = "github:tweag/opam-nix";
    opam-nix.inputs.nixpkgs.follows = "nixpkgs";
    opam-nix.inputs.opam-repository.follows = "opam-repository";
  };

  outputs =
    inputs@{
      flake-parts,
      import-tree,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./flake);
}
