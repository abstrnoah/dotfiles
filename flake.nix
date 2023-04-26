{
  description = "abstrnoah's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixphile.url = "github:abstrnoah/nixphile";
    wallpapers.url = "github:abstrnoah/wallpapers";
  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs_unstable, ... }:
    let
      lib_agnostic = import ./lib.nix {};
      for_all_systems = lib_agnostic.for_all [
        "x86_64-linux"
        # "armv7l-linux" # TODO (for raspberry pi)
      ];
      nixpkgs_for = system: input:
        import input {
          inherit system;
          config = import ./nixpkgs-config.nix { nixpkgs_lib = input.lib; };
        };
      inputs_for =
        system:
        builtins.mapAttrs (_: input: input.packages.${system}) inputs
        // {
          inherit system;
          nixpkgs = nixpkgs_for system nixpkgs;
          nixpkgs_unstable = nixpkgs_for system nixpkgs_unstable;
        };
    in
    rec {
      lib =
        (for_all_systems (system: import ./lib.nix (inputs_for system)))
        // { agnostic = lib_agnostic; };

      packages =
        for_all_systems
          (system:
          import ./default.nix
            ((inputs_for system) // { lib = lib.${system}; }));

      # TODO add default app
    };
}
