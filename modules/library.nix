{ inputs, ... }:
let
  library = import ../library.nix {
    # For flake version of lib which is different from non-flake version :skull:
    nixpkgs-lib = inputs.nixokgs.lib;
  };
  libraryM = {
    _module.args.libary = library;
  };
in
{
  imports = [ libraryM ];
}
