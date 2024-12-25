{

  description = "abstrnoah's dotfiles";

  inputs.systems.url = "github:nix-systems/default-linux";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.systems.follows = "systems";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.wallpapers.url = "github:abstrnoah/wallpapers";

  inputs.nixphile.url = "github:abstrnoah/nixphile?ref=dev"; # TODO
  inputs.nixphile.inputs.nixpkgs.follows = "nixpkgs";

  inputs.emplacetree.url = "github:abstrnoah/emplacetree";
  inputs.emplacetree.inputs.nixpkgs.follows = "nixpkgs";
  inputs.emplacetree.inputs.flake-utils.follows = "flake-utils";

  inputs.nix-on-droid.url = "github:nix-community/nix-on-droid/release-23.05";
  inputs.nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    inputs@{ self, flake-utils, nixpkgs, nixpkgs-unstable, nix-on-droid, ... }:
    let
      cons-nixpkgs = nixpkgs:
        flake-utils.lib.eachDefaultSystem (system:
          let nixpkgs' = import nixpkgs self.config.${system}.nixpkgs-args;
          in {
            nixpkgs = nixpkgs';
            legacyPackages = nixpkgs';
          }) // {
            inherit (nixpkgs) lib;
          };
      our-nixpkgs = cons-nixpkgs nixpkgs;
      our-nixpkgs-unstable = cons-nixpkgs nixpkgs-unstable;
      our-inputs = inputs // {
        nixpkgs = our-nixpkgs;
        nixpkgs-unstable = our-nixpkgs-unstable;
      };
      main = import ./packages.nix our-inputs;
      config = import ./config.nix our-inputs;
      nix-on-droid'.nixOnDroidConfigurations.default =
        nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [ ./nix-on-droid.nix ];
        };
    in main // config // nix-on-droid';

}
