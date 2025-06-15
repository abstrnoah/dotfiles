{
  flake.modules.nixos.cl =
    { config, ... }:
    {
      users.users.${config.brumal.owner}.shell = config.brumal.packages.zsh;
      programs.zsh.enable = true;
      environment.systemPackages = [ config.brumal.packages.tmux ];
    };
}
