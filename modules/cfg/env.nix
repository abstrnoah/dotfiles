{
  flake.nixosModules.base =
    { config, ownerName, ... }:
    {
      brumal.env = rec {
        HOME = "/home/${ownerName}";
        XDG_CONFIG_HOME = "${HOME}/.config";
        NIX_PROFILE = "${HOME}/.nix-profile";
      };
    };
}
