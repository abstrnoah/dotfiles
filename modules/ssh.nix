{
  flake.nixosModules.base = {
    programs.ssh.startAgent = true;
  };
}
