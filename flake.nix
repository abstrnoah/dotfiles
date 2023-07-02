{
  description = "abstrnoah's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixphile.url = "github:abstrnoah/nixphile";
    wallpapers.url = "github:abstrnoah/wallpapers";
    nix-on-droid = {
      url = "github:t184256/nix-on-droid/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs_unstable, nix-on-droid, ... }:
    let
      lib_agnostic = import ./lib.nix {};
      for_all_systems = lib_agnostic.for_all lib_agnostic.supported_systems;
      nixpkgs_for = system: input:
        import input {
          inherit system;
          config = import ./nixpkgs-config.nix { nixpkgs_lib = input.lib; };
        };
      inputs_for =
        system:
        builtins.mapAttrs (_: input: input.packages.${system} or {}) inputs
        // {
          inherit system;
          nixpkgs = nixpkgs_for system nixpkgs;
          nixpkgs_unstable = nixpkgs_for system nixpkgs_unstable;
        };
    in
    rec {
      lib =
        (for_all_systems (system: import ./lib.nix (inputs_for system)))
        // { agnostic = lib_agnostic; };

      dotfiles =
        for_all_systems
          (system:
          import ./default.nix
            ((inputs_for system) // { lib = lib.${system}; }));

      # Explicitly choose which packages to expose.
      packages = {
        x86_64-linux = dotfiles.x86_64-linux;

        aarch64-linux = {
          inherit (dotfiles.aarch64-linux)
          core_env
          default
          nix-on-droid
          ;
        };
      };

      # TODO This is temporary slapdash solution to deploying dotfiles in the
      # situation that I don't want to install Nix globally but do have/need to
      # use sudo.
      apps = for_all_systems (system: {
        minimal_nixless = {
          type = "app";
          program =
            let
              # It is important that all "paths" are _strings_ so nothing gets
              # copied to Nix store.
              src = "~/.dotfiles/dotfiles";
              assets = [
                [ "core_env" ".config/mimeapps.list" ".editrc" ".inputrc" ]
                [ "git" ".gitconfig" ]
                [ "tmux" ".tmux.conf" ]
                [ "vim" ".vim" ]
                [ "nix" ".config/nix/nix.conf" ]
              ];
              lns =
                builtins.concatMap (l: (map (p:
                let
                  source = "$HOME/.dotfiles/dotfiles/${builtins.head l}/home/me/${p}";
                  target = "$HOME/${p}";
                in
                ''ln -s "${source}" "${target}"'') (builtins.tail l)))
                assets;
              app = (inputs_for system).nixpkgs.writeShellApplication {
                name = "minimal_nixless";
                runtimeInputs = [ (inputs_for system).nixpkgs.git ];
                text = ''
                  git clone -o github https://github.com/abstrnoah/dotfiles "$HOME/.dotfiles"
                  mkdir -p "$HOME/.config" "$HOME/.config/nix"
                  ${builtins.concatStringsSep "\n" lns}

                  mkdir -p "$HOME/.vim/autoload"
                  cp -T "${self.packages.${system}.vim-plug}/home/me/.vim/autoload/plug.vim" "$HOME/.vim/autoload/plug.vim"
                '';
              };
            in
            "${app}/bin/${app.name}";
          };
      });

      nixOnDroidConfigurations.default =
        nix-on-droid.lib.nixOnDroidConfiguration {
          modules = [ ./nix-on-droid.nix ];
        };
    };
}
