inputs@{ flake-utils, nixpkgs, ... }:

flake-utils.lib.eachDefaultSystem (system:
  let
    config-system = {

      inherit (nixpkgs.nixpkgs.${system})
        writeTextDir writeShellApplication symlinkJoin runCommandLocal;
      inherit (nixpkgs.lib.attrsets) getLib genAttrs getAttrs;
      inherit (nixpkgs.lib.strings) escapeShellArg concatStrings getName;
      path-append = nixpkgs.lib.path.append;

      nixpkgs-args = {
        inherit system;
        config = {
          pulseaudio = true;
          allowUnfreePredicate = p:
          builtins.elem (config-system.getName p) [
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

      has-constructor-id = id: x:
        x.${config-system.brumal-names.constructor}.${config-system.brumal-names.id} or null
        == id;

      is-bundled =
        config-system.has-constructor-id config-system.brumal-names.bundle;

      bundle-list-packages = b:
        assert config-system.is-bundled b;
        builtins.attrValues b.${config-system.brumal-names.preimage}.packages;

      # TODO simplify lol
      # flatten-bundles :: [ Package | Bundle ] -> [ Package ]
      # We operate on lists rather than sets to avoid overriding packages.
      flatten-bundles = ps:
        builtins.concatMap (p:
          if config-system.is-bundled p then
            config-system.flatten-bundles (config-system.bundle-list-packages p)
          else
            [ p ]) ps;

      cons-function = id: f:
        let
          __functor = _: x:
            (f x) // {
              ${config-system.brumal-names.preimage} = x;
              ${config-system.brumal-names.constructor} = cons;
            };
          cons = {
            inherit __functor;
            ${config-system.brumal-names.id} = id;
          };
        in cons;

      bundle = config-system.cons-function config-system.brumal-names.bundle
        ({ name, packages, args ? { } }:
          let
            packages' =
              config-system.flatten-bundles (builtins.attrValues packages);
          in nixpkgs.nixpkgs.${system}.buildEnv ({
            inherit name;
            paths = packages';
            extraOutputsToInstall = [ "man" "doc" ];
          } // args));

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
          excludes' = map (p: config-system.path-append source p) excludes;
          filter = path: type: !builtins.elem (/. + path) excludes';
        in builtins.filterSource filter source;

      store-dotfiles = source:
        config-system.store-source {
          inherit source;
          excludes = [ "README.md" "default.nix" ];
        };

      machines.coyote = {
        xrandr-outputs.builtin = "LVDS1";
        xrandr-outputs.external = "VGA1";
      };

      call-with = args: f:
        f (config-system.getAttrs (builtins.attrNames (builtins.functionArgs f))
          args);

      cons-package = config@{ ... }:
        packages@{ ... }:
        cons:
        config'@{ ... }:
        packages'@{ ... }:
        config-system.call-with (packages // packages')
        (config-system.call-with (config // config') cons);

      bundle-dotfiles = upstreams: name:
        config-system.bundle {
          inherit name;
          packages = {
            package = upstreams.${name};
            rc = config-system.store-dotfiles
              (config-system.path-append config-system.src-path name);
          };
        };

      store-symlink = name: source: destination:
        config-system.store-symlinks {
          inherit name;
          mapping = [{ inherit source destination; }];
        };

      store-symlinks = { name, mapping }:
        let
          symlink-command = { source, destination }: ''
            destination="$out"/${config-system.escapeShellArg destination}
            mkdir -p "$(dirname "$destination")"
            ln -s ${config-system.escapeShellArg source} "$destination"
          '';
          commands = map symlink-command mapping;
        in config-system.runCommandLocal name { } ''
          mkdir -p "$out"
          cd "$out"
          ${config-system.concatStrings commands}
        '';

      systemd-user-units-path = "/home/me/.config/systemd/user";

      # config-system.brumal-names - An RDF-style namespace for attribute keys which will
      # eventually (TODO) be moved into a separate flake.
      brumal-names = config-system.genAttrs [
        # The argument that was passed to "constructor" to yield the object.
        "preimage"
        # The function which was applied to "preimage" to yield the object.
        "constructor"
        # The object's IRI, i.e. globally unique identifier.
        # We need this in order to equality-check things like functions.
        "id"
        # The IRI of the bundle function provided by this flake.
        "bundle"
      ] (n: "http://names.brumal.net/nix#${n}");

    };
  in { config = config-system; })
