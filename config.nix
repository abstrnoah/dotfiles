config@{ self, system, }:

{
  fold = builtins.foldl';

  cons-nixpkgs-packages =
    # the nixpkgs flake input
    nixpkgs:
    import nixpkgs {
      inherit system;
      config = {
        pulseaudio = true;
        allowUnfreePredicate = p:
          builtins.elem (nixpkgs.lib.getName p) [
            "discord"
            "spotify"
            "spotify-unwrapped"
            "vscode"
            "xflux"
            "zoom"
            "slack"
            "minecraft-launcher"
          ];
      };
    };

  nix-formatter-pack-args = {
    inherit system;
    pkgs = self.nixpkgs-packages;
    checkFiles = [ ./. ];
    config.tools.nixfmt.enable = true;
  };

} // config
