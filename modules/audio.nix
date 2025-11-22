{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;
      services.pipewire.enable = true;
      brumal.nixpkgs.allowUnfree = [ "spotify" ];
      brumal.profile.packages = [ pkgs.spotify ];
    };
}
