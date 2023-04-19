{
  description = "abstrnoah's dotfiles";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs =
    { self, nixpkgs }:
    let
      lib_agnostic = import ./lib.nix {};
      for_all_systems = lib_agnostic.for_all [
        "x86_64-linux"
        # "armv7l-linux" # TODO (for raspberry pi)
      ];
      nixpkgs_for =
        system:
        import nixpkgs {
          inherit system;
          config = import ./nixpkgs-config.nix { nixpkgs_lib = nixpkgs.lib; };
        };
    in
    rec {
      lib =
        (for_all_systems
          (system: import ./lib.nix { nixpkgs = nixpkgs_for system; }))
        // { agnostic = lib_agnostic; };

      packages = for_all_systems
          (system:
          (import ./default.nix {
            inherit system;
            lib = lib.${system};
            nixpkgs = nixpkgs_for system;
          }).packages);
    };
}
