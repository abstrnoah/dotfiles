{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    dotfiles.url = "github:abstrnoah/dotfiles";
    dotfiles.inputs.flake-parts.follows = "flake-parts";
    dotfiles.inputs.import-tree.follows = "import-tree";
    dotfiles.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      flake-parts,
      import-tree,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./flake);
}
