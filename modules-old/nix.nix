{
  flake.modules.brumal.nix =
    {
      config,
      lib,
      library,
      mkCases,
      ...
    }:
    {
      options.nix-settings = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.anything;
        description = ''
          Nix settings like in nixos modules `nix.settings` or `nix.conf`.
          We bring them out here to automatically generate both nixos module and conf file.
        '';
        default = { };
      };

      config = mkCases config.distro {
        "*".nix-settings = {
          experimental-features = [
            "nix-command"
            "flakes"
            "repl-flake"
            "pipe-operators"
          ];
          allow-import-from-derivation = true;
        };

        debian.legacyDotfiles.nix =
          let
            text = lib.concatLines (
              lib.mapAttrsToList (name: value: "${name} = ${toString value}") config.nix-settings
            );
          in
          library.writeTextFile {
            name = "nix.conf";
            destination = "/home/me/.config/nix/nix.conf";
            inherit text;
          };

        nixos.nixos.settings = config.nix-settings;
      };
    };
}
