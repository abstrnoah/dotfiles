inputs@{ flake-utils, nixpkgs, ... }:

flake-utils.lib.eachDefaultSystem (system:
  let
    config-system = {

      write-text = nixpkgs.nixpkgs.${system}.writeTextDir;
      write-shell-app = nixpkgs.nixpkgs.${system}.writeShellApplication;
      symlink-join = nixpkgs.nixpkgs.${system}.symlinkJoin;
      run-command-local = nixpkgs.nixpkgs.${system}.runCommandLocal;
      get-lib-output = nixpkgs.lib.attrsets.getLib;
      gen-attrs = nixpkgs.lib.attrsets.genAttrs;
      get-attrs = nixpkgs.lib.attrsets.getAttrs;
      escape-shell-arg = nixpkgs.lib.strings.escapeShellArg;
      concat-strings = nixpkgs.lib.strings.concatStrings;
      get-name-substring = nixpkgs.lib.strings.getName;
      path-append = nixpkgs.lib.path.append;

      nixpkgs-args = {
        inherit system;
        config = {
          pulseaudio = true;
          allowUnfreePredicate = p:
            builtins.elem (config-system.get-name-substring p) [
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

      is-bundled = b: b ? brumal.bundle-packages;

      bundle-list-packages = b:
        assert config-system.is-bundled b;
        builtins.attrValues b.brumal.bundle-packages;

      # flatten-bundles :: [ Package | Bundle ] -> [ Package ]
      # We operate on lists rather than sets to avoid overriding packages.
      flatten-bundles = ps:
        builtins.concatMap (p:
          if config-system.is-bundled p then
            config-system.flatten-bundles (config-system.bundle-list-packages p)
          else
            [ p ]) ps;

      bundle = { name, packages, args ? { } }:
        let
          packages' =
            config-system.flatten-bundles (builtins.attrValues packages);
        in nixpkgs.nixpkgs.${system}.buildEnv ({
          inherit name;
          paths = packages';
          extraOutputsToInstall = [ "man" "doc" ];
        } // args) // {
          brumal.bundle-packages = packages;
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
        f
        (config-system.get-attrs (builtins.attrNames (builtins.functionArgs f))
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
            destination="$out"/${config-system.escape-shell-arg destination}
            mkdir -p "$(dirname "$destination")"
            ln -s ${config-system.escape-shell-arg source} "$destination"
          '';
          commands = map symlink-command mapping;
        in config-system.run-command-local name { } ''
          mkdir -p "$out"
          cd "$out"
          ${config-system.concat-strings commands}
        '';

      systemd-user-units-path = "/home/me/.config/systemd/user";

    };
  in { config = config-system; })
