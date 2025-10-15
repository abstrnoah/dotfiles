{
  flake.nixosModules.base.nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    allow-import-from-derivation = true;
  };
}
