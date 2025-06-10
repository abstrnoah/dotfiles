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

        nixos.nixos.nix.settings = config.nix-settings;
      };
    };
}
