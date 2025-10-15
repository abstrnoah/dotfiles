{ inputs, ... }:
let
  library = import ../library.nix {
    # For flake version of lib which is different from non-flake version :skull:
    nixpkgs-lib = inputs.nixpkgs.lib;
  };
  libraryM = {
    _module.args.library = library;
  };
in
{
  imports = [ libraryM ];
}
