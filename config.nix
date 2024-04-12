config@{ self, system, }:

{
  fold = builtins.foldl';

  cons-nixpkgs-packages = nixpkgs: # nixpkgs flake input
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
    pkgs = self.nixpkgs;
    checkFiles = [ ./. ];
    config.tools.nixfmt.enable = true;
  };
} // config
