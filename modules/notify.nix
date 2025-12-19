{
  flake.nixosModules.base =
    {
      pkgs,
      config,
      utilities,
      ...
    }:
    let
      inherit (utilities)
        writeShellApplication
        ;
      k = config.brumal.i3wm.keys;
      notifyToggleScript = writeShellApplication {
        name = "notify-toggle-script";
        runtimeInputs = [
          pkgs.dunst
          pkgs.libnotify
        ];
        text = ''
          dunstctl set-paused toggle
          test "$(dunstctl is-paused)" = false || notify-send "notifying"
        '';
      };
    in
    {
      services.dbus.packages = [
        pkgs.dunst
      ];
      systemd.packages = [
        pkgs.dunst
      ];
      environment.systemPackages = [
        pkgs.libnotify
        pkgs.dunst
      ];
      brumal.i3wm.body.bindsym."${k.alt}+n" = "exec ${notifyToggleScript}/bin/notify-toggle-script";
    };
}
