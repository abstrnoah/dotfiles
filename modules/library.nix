{ lib, ... }:
let
  library = import ../library.nix { nixpkgs-lib = lib; };
  libraryModule = {
    _module.args.library = library;
  };
in
{
  imports = [ libraryModule ];
  options.flake.library = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.anything;
    default = { };
    description = "Libraries are system-agnostic!";
  };
  config.flake = {
    inherit library;
    modules.flake.library = libraryModule;
    # modules.brumal.library = libraryModule; # Instead, this is injected directly in /library.nix.
  };
}
