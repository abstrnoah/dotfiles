{
  description = "abstrnoah's dotfiles";

  inputs.systems.url = "github:nix-systems/default-linux";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.systems.follows = "systems";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.wallpapers.url = "github:abstrnoah/wallpapers";

  inputs.nixphile.url = "github:abstrnoah/nixphile?ref=dev";
  inputs.nixphile.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-on-droid.url = "github:nix-community/nix-on-droid/release-23.05";
  inputs.nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-formatter-pack.url = "github:Gerschtli/nix-formatter-pack";

  outputs = inputs@{ ... }:
    let

      # brumal-names - An RDF-style namespace for attribute keys which will
      # eventually (TODO) be moved into a separate flake.
      brumal-names = inputs.nixpkgs.lib.genAttrs [
        # The argument that was passed to "constructor" to yield the object.
        "preimage"
        # The function which was applied to "preimage" to yield the object.
        "constructor"
        # The object's IRI, i.e. globally unique identifier.
        # We need this in order to equality-check things like functions.
        "id"
        # The IRI of the bundle function provided by this flake.
        "bundle"
      ] (n: "http://names.brumal.net/nix#${n}");

      # choose-system ["key" ...] input -> { key = input.key.system; ... }
      choose-system = system: keys: input:
        builtins.mapAttrs
        (key: value: if builtins.elem key keys then value.${system} else value)
        input;
      # keys whose values are sets organised by system
      keys-by-system =
        [ "config" "our-nixpkgs" "our-nixpkgs-unstable" "packages" "apps" ];

      # outputs organised by system
      outputs-by-system = inputs.flake-utils.lib.eachDefaultSystem (system:
        let
          inputs-for-system = builtins.mapAttrs
            (_: input: choose-system system keys-by-system input) inputs;
        in with inputs-for-system; {
          config = import ./config.nix { inherit self system brumal-names; };
          our-nixpkgs = self.config.cons-nixpkgs nixpkgs;
          our-nixpkgs-unstable = self.config.cons-nixpkgs nixpkgs-unstable;
          packages = import ./default.nix
            (inputs-for-system // { inherit brumal-names; });
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
