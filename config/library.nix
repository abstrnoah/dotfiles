# TODO Also make library a module argument

{ inputs, ... }:
{
  config.perSystem =
    { config, system, ... }:
    {
      config.library = import ../library.nix {
        inherit system;
        inherit (inputs) nixpkgs;
      };
    };
}
