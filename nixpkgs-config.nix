{ nixpkgs_lib }:
{
  pulseaudio = true;

  allowUnfreePredicate =
    p:
    builtins.elem (nixpkgs_lib.getName p) [
      "discord"
      "spotify"
      "spotify-unwrapped"
      "vscode"
      "xflux"
      "zoom"
      "slack"
      "minecraft-launcher"
    ];
}
