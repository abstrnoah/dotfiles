{
  flake.nixosModules.base =
    { config, ... }:
    {
      brumal.env = rec {
        HOME = "/home/${config.brumal.owner}";
        XDG_CONFIG_HOME = "${HOME}/.config";
        NIX_PROFILE = "${HOME}/.nix-profile";
      };
    };
}
