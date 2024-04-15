config@{ self, system, brumal-names }:

{
  # TODO deprecate
  legacy = import ./lib.nix { nixpkgs = self.our-nixpkgs; };

  fold = builtins.foldl';

  get-attrs = keys: set: map (key: builtins.getAttr key set) keys;
  get-attrs' = set: keys: self.config.get-attrs keys set;

  has-constructor-id = id: x:
    x.${brumal-names.constructor}.${brumal-names.id} == id;

  is-bundled = self.config.has-constructor-id brumal-names.bundle;

  bundle-get-packages = b:
    assert self.config.is-bundled b;
    b.${brumal-names.preimage}.packages;

  flatten-bundles = ps:
    self.our-nixpkgs.lib.concatMapAttrs (name: value:
      if self.config.is-bundled value then
        self.config.flatten-bundles (self.config.bundle-get-packages value)
      else {
        ${name} = value;
      }) ps;

  cons-function = id: f:
    let
      __functor = x:
        (f x) // {
          ${brumal-names.preimage} = x;
          ${brumal-names.constructor} = cons;
        };
      cons = {
        inherit __functor;
        ${brumal-names.id} = id;
      };
    in cons;

  bundle = self.config.cons-function brumal-names.bundle
    ({ name, packages, args, }:
      let packages' = self.config.flatten-bundles packages;
      in self.our-nixpkgs.buildEnv ({
        inherit name;
        paths = builtins.attrValues packages';
        extraOutputsToInstall = [ "man" "doc" ];
      } // args));

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
