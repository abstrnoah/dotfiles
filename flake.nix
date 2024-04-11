{
  description = "abstrnoah's dotfiles";

  inputs.systems.url = "github:nix-systems/default-linux";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.systems.follows = "systems";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.wallpapers.url = "github:abstrnoah/wallpapers";

  inputs.nix-on-droid.url = "github:nix-community/nix-on-droid/release-23.05";
  inputs.nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    inputs@{ self, ... }:
    let
      # choose-system ["key" ...] input -> { key = input.key.system; ... }
      choose-system =
        system: keys: input:
        builtins.mapAttrs
          (key: value:
            if builtins.elem key keys then value.${system} else value)
          input;
      # keys whose values are sets organised by system
      keys-by-system =
        ["config" "nixpkgs" "nixpkgs-unstable" "packages" "apps"];
      # outputs organised by system
      outputs-by-system =
        flake-utils.lib.eachDefaultSystem
          (system:
          let
            inputs-for-system =
              builtins.mapAttrs
                (_: input: choose-system system keys-by-system input)
                inputs;
          in with inputs-for-system;
            { config = # TODO turn into a local flake input
                import ./config.nix
                  { inherit system ;
                    inherit (nixpkgs.lib) getName; };
              nixpkgs = self.config.cons-nixpkgs-packages nixpkgs;
              nixpkgs-unstable = self.config.cons-nixpkgs-packages nixpkgs-unstable;
              packages = import ./default.nix inputs-for-system; };
      # outputs not organised by system
      outputs-any-system =
        { nixOnDroidConfigurations.default =
            nix-on-droid.lib.nixOnDroidConfiguration
              { modules = [ ./nix-on-droid.nix ]; }; };
    in
      outputs-by-system // outputs-any-system;
}
