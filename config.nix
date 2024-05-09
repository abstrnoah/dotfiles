inputs@{ self, flake-utils, nixpkgs, ... }:

flake-utils.lib.eachDefaultSystem (system:
  let
    this = {

      username = "abstrnoah";
      src-path = ./src;
      dotfiles-source = "https://github.com/abstrnoah/dotfiles";
      dotfiles-destination = "$HOME/.dotfiles";
      machines.coyote = {
        xrandr-outputs.builtin = "LVDS1";
        xrandr-outputs.external = "VGA1";
        battery-device = "BAT0";
      };
      systemd-user-units-path = "/home/me/.config/systemd/user";
      shell = "${self.packages.${system}.zsh}/bin/zsh";
      hibernator = "systemctl hibernate";
      wttrin-cache-path = "/tmp/latest-wttrin";

      nixpkgs-args = {
        inherit system;
        config = {
          pulseaudio = true;
          allowUnfreePredicate = p:
            builtins.elem (this.get-name-substring p) [
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

      fold = builtins.foldl';
      write-text = nixpkgs.nixpkgs.${system}.writeTextFile;
      write-shell-app = nixpkgs.nixpkgs.${system}.writeShellApplication;
      symlink-join = nixpkgs.nixpkgs.${system}.symlinkJoin;
      run-command-local = nixpkgs.nixpkgs.${system}.runCommandLocal;
      substitute = nixpkgs.nixpkgs.${system}.substitute;
      get-lib-output = nixpkgs.lib.attrsets.getLib;
      gen-attrs = nixpkgs.lib.attrsets.genAttrs;
      get-attrs = nixpkgs.lib.attrsets.getAttrs;
      escape-shell-arg = nixpkgs.lib.strings.escapeShellArg;
      to-shell-var = nixpkgs.lib.strings.toShellVar;
      concat-strings = nixpkgs.lib.strings.concatStrings;
      get-name-substring = nixpkgs.lib.strings.getName;
      path-append = nixpkgs.lib.path.append;

      is-bundled = b: b ? brumal.bundle-packages;

      bundle-list-packages = b:
        assert this.is-bundled b;
        builtins.attrValues b.brumal.bundle-packages;

      # flatten-bundles :: [ Package | Bundle ] -> [ Package ]
      # We operate on lists rather than sets to avoid overriding packages.
      flatten-bundles = ps:
        builtins.concatMap (p:
          if this.is-bundled p then
            this.flatten-bundles (this.bundle-list-packages p)
          else
            [ p ]) ps;

      bundle = { name, packages, args ? { } }:
        let packages' = this.flatten-bundles (builtins.attrValues packages);
        in nixpkgs.nixpkgs.${system}.buildEnv ({
          inherit name;
          paths = packages';
          extraOutputsToInstall = [ "man" "doc" ];
        } // args) // {
          brumal.bundle-packages = packages;
        };

      # TODO `nix flake show` complains that this does not produce a derivation,
      # although `nix flake build`ing works fine.
      store-source = {
        # Absolute path to the source, must not be a store path.
        source,
        # List of path strings to exclude, relative to source.
        excludes ? [ ] }:
        assert builtins.typeOf source == "path";
        let
          name = baseNameOf source;
          excludes' = map (p: this.path-append source p) excludes;
          filter = path: type: !builtins.elem (/. + path) excludes';
        in builtins.filterSource filter source;

      store-dotfiles = name:
        this.store-source {
          source = this.path-append this.src-path name;
          excludes = [ "README.md" "default.nix" ];
        };

      call = f: arg:
        f (this.get-attrs (builtins.attrNames (builtins.functionArgs f)) arg);

      calls = f: args: this.fold this.call f args;

      cons-package = config@{ ... }:
        packages@{ ... }:
        cons:
        config'@{ ... }:
        packages'@{ ... }:
        this.calls cons [ (config // config') (packages // packages') ];

      cons-package-named = config: packages: name:
        this.cons-package config packages
        (import (this.path-append this.src-path name));

      bundle-dotfiles = upstreams: name:
        this.bundle {
          inherit name;
          packages = {
            package = upstreams.${name};
            rc = this.store-dotfiles name;
          };
        };

      store-symlink = name: source: destination:
        this.store-symlinks {
          inherit name;
          mapping = [{ inherit source destination; }];
        };

      store-symlinks = { name, mapping }:
        let
          symlink-command = { source, destination }: ''
            destination="$out"/${this.escape-shell-arg destination}
            mkdir -p "$(dirname "$destination")"
            ln -s ${this.escape-shell-arg source} "$destination"
          '';
          commands = map symlink-command mapping;
        in this.run-command-local name { } ''
          mkdir -p "$out"
          cd "$out"
          ${this.concat-strings commands}
        '';

    };
  in { config = this; })
