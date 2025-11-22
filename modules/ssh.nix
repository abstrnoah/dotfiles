{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      programs.ssh.startAgent = true;
      programs.ssh.extraConfig = ''
        Host tipu
          HostName tipu.brumal.net
          Port 2202
          ProxyCommand ${pkgs.netcat}/bin/nc -X connect -x %h:443 %h %p
          User abstractednoah
        Host tipu.local
          HostName tipu.local
          Port 2202
          User abstractednoah
      '';
    };
}
