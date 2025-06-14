{ lib, ... }:
let
  library = import ../library.nix { nixpkgs-lib = lib; };
  libraryModule = {
    _module.args.library = library;
  };
in
{
  imports = [ libraryModule ];
  options.library = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.anything;
    default = { };
    description = "Libraries are system-agnostic!";
  };
  config = {
    inherit library;
    flake.modules.flake.library = libraryModule;
    flake.modules.brumal.library = libraryModule;
  };
}
