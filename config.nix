config@{ self, system, brumal-names }:

{
  # TODO deprecate
  legacy = import ./lib.nix { nixpkgs = self.our-nixpkgs; };

  # TODO
  inherit (self.our-nixpkgs) writeTextDir;
  inherit (self.our-nixpkgs.lib) getLib;

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
    # Absolute path to the source, must not be a store path.
    source,
    # List of path strings to exclude, relative to source.
    excludes ? [ ] }:
    assert builtins.typeOf source == "path";
    let
      name = baseNameOf source;
      excludes' = map (p: self.our-nixpkgs.lib.path.append source p) excludes;
      filter = path: type: !builtins.elem (/. + path) excludes';
    in builtins.filterSource filter source;

  store-dotfiles = source:
    self.config.store-source {
      inherit source;
      excludes = [ "README.md" "default.nix" ];
    };

  machines.coyote = {
    xrandr-outputs.builtin = "LVDS1";
    xrandr-outputs.external = "VGA1";
  };

  call-with = args: f:
    f (self.our-nixpkgs.lib.attrsets.getAttrs
      (builtins.attrNames (builtins.functionArgs f)) args);

  cons-package = config@{ ... }:
    packages@{ ... }:
    cons:
    config'@{ ... }:
    packages'@{ ... }:
    self.config.call-with (packages // packages')
    (self.config.call-with (config // config') cons);

  store-symlink = name: source: destination:
    self.config.store-symlinks {
      inherit name;
      mapping = [{ inherit source destination; }];
    };

  store-symlinks = { name, mapping }:
    let
      symlink-command = { source, destination }: ''
        destination="$out"/${self.our-nixpkgs.lib.escapeShellArg destination}
        mkdir -p "$(dirname "$destination")"
        ln -s ${self.our-nixpkgs.lib.escapeShellArg source} "$destination"
      '';
      commands = map symlink-command mapping;
    in self.our-nixpkgs.runCommandLocal name { } ''
      mkdir -p "$out"
      cd "$out"
      ${self.our-nixpkgs.lib.concatStrings commands}
    '';

} // config
