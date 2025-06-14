{
  lib,
  ...
}:
let
  library = import ../library.nix { nixpkgs-lib = lib; };
in
{
  options.library = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.anything;
    default = { };
    description = "Libraries are system-agnostic!";
  };

  config = {
    inherit library;
    _module.args.library = library;
  };
}
