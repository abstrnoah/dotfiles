{ getName }: {
  pulseaudio = true;

  allowUnfreePredicate = p:
    builtins.elem (getName p) [
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
