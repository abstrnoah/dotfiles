config@{
  system
, getName
}:

{
  fold = builtins.foldl';

  cons-nixpkgs-packages =
    nixpkgs: # nixpkgs flake input
    import nixpkgs
      { inherit system;
        config =
          { pulseaudio = true;
            allowUnfreePredicate =
              p:
              builtins.elem (getName p) [
                "discord"
                "spotify"
                "spotify-unwrapped"
                "vscode"
                "xflux"
                "zoom"
                "slack"
                "minecraft-launcher"
              ]; }; };
}
//
config
