{
  description = "abstrnoah's dotfiles";

  inputs.systems.url = "github:nix-systems/default-linux";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.systems.follows = "systems";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.wallpapers.url = "github:abstrnoah/wallpapers";

  inputs.nixphile.url = "github:abstrnoah/nixphile";
  inputs.nixphile.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-on-droid.url = "github:nix-community/nix-on-droid/release-23.05";
  inputs.nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";

  outputs =
    inputs@{ ... }:
    let
      # choose-system ["key" ...] input -> { key = input.key.system; ... }
      choose-system = system: keys: input:
        builtins.mapAttrs
        (key: value: if builtins.elem key keys then value.${system} else value)
        input;
      # keys whose values are sets organised by system
      keys-by-system = [
        "config"
        "nixpkgs-packages"
        "nixpkgs-unstable-packages"
        "packages"
        "apps"
      ];
      # outputs organised by system
      outputs-by-system = inputs.flake-utils.lib.eachDefaultSystem (system:
        let
          inputs-for-system = builtins.mapAttrs
            (_: input: choose-system system keys-by-system input) inputs;
        in with inputs-for-system; {
          config = import ./config.nix { inherit self system; };
          nixpkgs-packages = self.config.cons-nixpkgs-packages nixpkgs;
          nixpkgs-unstable-packages =
            self.config.cons-nixpkgs-packages nixpkgs-unstable;
          packages = import ./default.nix inputs-for-system;
          checks.nix-formatter-pack-check =
            nix-formatter-pack.lib.mkCheck self.config.nix-formatter-pack-args;
          formatter = nix-formatter-pack.lib.mkFormatter
            self.config.nix-formatter-pack-args;
        });
      # outputs not organised by system
      outputs-any-system = {
        nixOnDroidConfigurations.default =
          inputs.nix-on-droid.lib.nixOnDroidConfiguration {
            modules = [ ./nix-on-droid.nix ];
          };
      };
    in outputs-by-system // outputs-any-system;
}
