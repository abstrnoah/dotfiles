{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      brumal.profile.packages = [
        pkgs.discord
        pkgs.signal-desktop
        pkgs.telegram-desktop
      ];
      brumal.nixpkgs.allowUnfree = [
        "discord"
      ];
    };
}
