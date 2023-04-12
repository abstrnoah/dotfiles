{
  description = "abstrnoah's dotfiles";

  inputs.nixpkgs.url =
    "github:abstrnoah/nixpkgs/37c045276cbedf0651305c564e7b696df12bc5fc";

  outputs =
    { self, nixpkgs }:
    let
      # these are just the tested systems, probably would work anywhere
      supported_systems = [ "x86_64-linux" "armv7l-linux" ];
      lib_basic = import ./lib.nix {};
      for_all_systems = f: lib_basic.gen_set f supported_systems;
      nixpkgs_f = system: import nixpkgs { inherit system; };
      lib_f = system: import ./lib.nix { nixpkgs = nixpkgs_f system; };
      envs_f =
        system:
        (import ./default.nix { lib = lib_f system; }).envs;
    in
    rec {
      lib = for_all_systems lib_f // { basic = lib_basic; };
      # In this flake, "package" means "env".
      # For example, the "install" package is the env used by the ./install
      # script; it is not an installer itself.
      packages = for_all_systems envs_f;
    };
}
