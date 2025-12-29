{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      i18n.defaultLocale = "en_US.UTF-8";
      time.timeZone = null;
      brumal.local.hooks = [
        ''${pkgs.systemd}/bin/timedatectl set-timezone "$TIMEZONE"''
      ];
      brumal.i3status.blocks.tztime = {
        local.format = "󰖉 %a %Y-%m-%d %H:%M:%S %Z";
        utc.format = " %H:%M";
        utc.timezone = "UTC";
      };
    };
}
