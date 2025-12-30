{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      brumal.profile.packages = [
        pkgs.curl
      ];
      brumal.files.home.".curlrc".text = "silent";
    };
}
