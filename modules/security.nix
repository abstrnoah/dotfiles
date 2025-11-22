{
  flake.nixosModules.base =
    {
      config,
      pkgs,
      ...
    }:
    {
      brumal.profile.packages = [
        pkgs.tomb
        pkgs.gnupg
        pkgs.pass
      ];
      security.sudo.extraRules = [
        {
          commands = [
            {
              command = "${pkgs.tomb}/bin/tomb";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ config.brumal.sudoGroup ];
        }
      ];
    };
}
