{
  brumal.nixpkgs.allowUnfree = [
    "discord"
    "zoom"
  ];

  flake.nixosModules.base =
    { pkgs, ... }:
    {
      brumal.profile.packages = [
        pkgs.discord
        pkgs.signal-desktop
        pkgs.telegram-desktop
        pkgs.zoom-us
      ];
    };
}
