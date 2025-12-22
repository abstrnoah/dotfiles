{
  flake.nixosModules.base =
    {
      config,
      pkgs,
      ...
    }:
    {
      # TODO I'd really prefer to not have to install cryptsetup,pinentry like this. However tomb's internal sudo calls break its nixpkgs PATH wrapper so requires its dependencies installed implicity.
      environment.systemPackages = [
        pkgs.tomb
        pkgs.gnupg
        pkgs.cryptsetup
        pkgs.pinentry-all # TODO TEST
      ];
      programs.gnupg.agent.enable = true;
      security.sudo.extraRules = [
        {
          commands = [
            {
              # Necessary that we use run instead of store path for unqualified command to be recognised.
              command = "/run/current-system/sw/bin/tomb";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ config.brumal.sudoGroup ];
        }
      ];
      environment.etc."sudo.conf" = {
        text = ''
          Path askpass ${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass
        '';
        mode = "0440";
      };
    };
}
