{
  flake.nixosModules.base.nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    allow-import-from-derivation = true;
    trusted-users = [
      "@wheel"
    ];
    extra-substituters = [
      "https://forester.cachix.org"
    ];
    extra-trusted-public-keys = [
      "forester.cachix.org-1:pErGVVci7kZWxxcbQ/To8Lvqp6nVTeyPf0efJxbrQDM="
    ];
  };
}
