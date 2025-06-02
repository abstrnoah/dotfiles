args@{ system, nixpkgs, ... }:
let
  nixpkgs = import args.nixpkgs {
    inherit system;
    # TODO  This was from old dotfiles; how to handle this config now?
    # config = {
    #   pulseaudio = true;
    #   allowUnfreePredicate = p:
    #     builtins.elem (this.get-name-substring p) [
    #       "discord"
    #       "spotify"
    #       "spotify-unwrapped"
    #       "vscode"
    #       "xflux"
    #       "zoom"
    #       "slack"
    #       "minecraft-launcher"
    #     ];
    # };
  };
  nixpkgs-lib = nixpkgs.lib;
in
let
  inherit (builtins)
    attrValues
    ;
  inherit (nixpkgs)
    buildEnv
    ;
in
{
  mergePackages =
    {
      name,
      packages,
      args ? { },
    }:
    buildEnv (
      {
        inherit name;
        paths = attrValues packages;
        # TODO Is this the right place to do this?
        extraOutputsToInstall = [
          "man"
          "doc"
        ];
      }
      // args
    );
}
