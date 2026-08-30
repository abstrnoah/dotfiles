{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    programs.ocamlformat.enable = true;
    programs.nixfmt.enable = true;
  };
}
