{
  flake.nixosModules.base = {
    services.logind.settings.Login.HanldeLidSwitch = "ignore";
    programs.xss-lock.enable = true;
  };
}
