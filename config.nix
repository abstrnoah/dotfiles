config@{ self, system }:

{
  # TODO deprecate
  legacy = import ./lib.nix { nixpkgs = self.our-nixpkgs; };

  fold = builtins.foldl';

  get-attrs = keys: set: map (key: builtins.getAttr key set) keys;
  get-attrs' = set: keys: self.config.get-attrs keys set;

  cons-nixpkgs =
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
    pkgs = self.our-nixpkgs;
    checkFiles = [ ./. ];
    config.tools.nixfmt.enable = true;
  };

  username = "abstrnoah";

} // config
