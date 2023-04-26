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
      for_all_systems = lib_agnostic.for_all lib_agnostic.supported_systems;
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

      dotfiles =
        for_all_systems
          (system:
          import ./default.nix
            ((inputs_for system) // { lib = lib.${system}; }));

      # Explicitly choose which packages to expose.
      packages = {
        x86_64-linux = dotfiles.x86_64-linux;

        aarch64-linux = {
          inherit (dotfiles.aarch64-linux)
          core_env
          default
          nix-on-droid
          ;
        };
      };

      # TODO add default app
    };
}
