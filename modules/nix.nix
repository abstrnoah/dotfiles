{
  flake.nixosModules.base.nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "repl-flake"
      "pipe-operators"
    ];
    allow-import-from-derivation = true;
  };
}
