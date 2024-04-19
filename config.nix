config@{ self, system, brumal-names }:

{
  # TODO deprecate
  legacy = import ./lib.nix { nixpkgs = self.our-nixpkgs; };

  has-constructor-id = id: x:
    x.${brumal-names.constructor}.${brumal-names.id} or null == id;

  is-bundled = self.config.has-constructor-id brumal-names.bundle;

  bundle-list-packages = b:
    assert self.config.is-bundled b;
    builtins.attrValues b.${brumal-names.preimage}.packages;

  # flatten-bundles :: [ Package | Bundle ] -> [ Package ]
  # We operate on lists rather than sets to avoid overriding packages.
  flatten-bundles = ps:
    builtins.concatMap (p:
      if self.config.is-bundled p then
        self.config.flatten-bundles (self.config.bundle-list-packages p)
      else
        [ p ]) ps;

  cons-function = id: f:
    let
      __functor = _: x:
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
    ({ name, packages, args ? { } }:
      let
        packages' = self.config.flatten-bundles (builtins.attrValues packages);
      in self.our-nixpkgs.buildEnv ({
        inherit name;
        paths = packages';
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

  src-path = ./src;

  dotfiles-source = "https://github.com/abstrnoah/dotfiles";
  dotfiles-destination = "$HOME/.dotfiles";

  store-source = {
    # Absolute source path to store, must not be a store path.
    source,
    # List of absolute paths to exclude.
    excludes ? [ ] }:
    # To ensure correct equality testing.
    assert builtins.all (p: builtins.typeOf p == "path") excludes;
    let
      name = baseNameOf source;
      filter = path: type: !builtins.elem (/. + path) excludes;
    in builtins.filterSource filter source;

  store-dotfiles = name:
    self.config.store-source { source = ./src + "/${name}"; };

} // config
