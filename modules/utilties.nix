{
  flake.nixosModules.base =
    { pkgs, library, ... }:
    {
      _module.args.utilities = import ../utilities.nix {
        inherit library;
        nixpkgs = pkgs;
      };
    };
}
