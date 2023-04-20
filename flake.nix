{
  description = "abstrnoah's dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  inputs.nixphile.url = "github:abstrnoah/nixphile";

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      lib_agnostic = import ./lib.nix {};
      for_all_systems = lib_agnostic.for_all [
        "x86_64-linux"
        # "armv7l-linux" # TODO (for raspberry pi)
      ];
      inputs_for =
        system:
        builtins.mapAttrs (_: input: input.packages.${system}) inputs
        // {
          inherit system;
          nixpkgs = import nixpkgs {
            inherit system;
            config = import ./nixpkgs-config.nix { nixpkgs_lib = nixpkgs.lib; };
          };
        };
    in
    rec {
      lib =
        (for_all_systems (system: import ./lib.nix (inputs_for system)))
        // { agnostic = lib_agnostic; };

      packages =
        for_all_systems
          (system:
          lib_agnostic.get "packages"
            (import ./default.nix
              ((inputs_for system) // { lib = lib.${system}; })));
    };
}
