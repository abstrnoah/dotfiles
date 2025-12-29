{
  brumal.nixpkgs.allowUnfree = [ "spotify" ];
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;
      services.pipewire.enable = true;
      brumal.profile.packages = [ pkgs.spotify ];
    };
}
