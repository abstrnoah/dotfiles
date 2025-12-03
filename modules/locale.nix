{
  flake.nixosModules.base = {
    # Set imperatively via timedatectl (TODO setup better persistent-but-noncommited locale system)
    time.timeZone = null;
    i18n.defaultLocale = "en_US.UTF-8";
  };
  # TODO
  # flake.modules.nixos.wm.brumal.cfg.i3status.blocks.tztime = {
  #   local.format = "%a %Y-%m-%d %H:%M:%S %Z";
  #   utc.format = "(%H %Z)";
  #   utc.timezone = "UTC";
  # };
}
