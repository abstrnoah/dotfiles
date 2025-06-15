{ inputs, ... }:
let
  library = import ../library.nix {
    # For flake version of lib which is different from non-flake version :skull:
    nixpkgs-lib = inputs.nixpkgs.lib;
  };
  libraryModule = {
    _module.args.library = library;
  };
in
{
  imports = [ libraryModule ];
  options.flake.library = library.mkOption {
    type = library.types.lazyAttrsOf library.types.anything;
    default = { };
    description = "Libraries are system-agnostic!";
  };
  config.flake = {
    inherit library;
    modules.flake.library = libraryModule;
    # modules.nixos.library = libraryModule; # Instead, this is injected directly in /library.nix.
  };
}
