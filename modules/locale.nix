{
  flake.nixosModules.base =
    { pkgs, config, ... }:
    {
      i18n.defaultLocale = "en_US.UTF-8";
      time.timeZone = null;
      brumal.local.variables.TIMEZONE.default = "America/New_York";
      brumal.local.variables.LATITUDE.default = "40.44";
      brumal.local.variables.LONGITUDE.default = "-79.94";
      brumal.local.hooks = [
        ''${pkgs.systemd}/bin/timedatectl set-timezone ${config.brumal.local.variables.TIMEZONE.shellValue}''
      ];
      brumal.i3status.blocks.tztime = {
        local.format = "󰖉 %a %Y-%m-%d %H:%M:%S %Z";
        utc.format = " %H:%M";
        utc.timezone = "UTC";
      };
    };
}
