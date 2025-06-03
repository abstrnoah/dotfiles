{

  description = "abstrnoah's dotfiles";

  nixConfig.extra-experimental-features = [ "pipe-operators" ];

  inputs.systems.url = "github:nix-systems/default-linux";

  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  inputs.import-tree.url = "github:vic/import-tree";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.wallpapers.url = "github:abstrnoah/wallpapers";

  inputs.nixphile.url = "github:abstrnoah/nixphile?ref=dev"; # TODO
  inputs.nixphile.inputs.nixpkgs.follows = "nixpkgs";

  inputs.emplacetree.url = "github:abstrnoah/emplacetree";
  inputs.emplacetree.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-on-droid.url = "github:nix-community/nix-on-droid/release-23.05";
  inputs.nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    inputs@{
      flake-parts,
      import-tree,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);

}
