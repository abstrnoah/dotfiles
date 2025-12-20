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
      dunstctl = "${pkgs.dunst}/bin/dunstctl";
    in
    {
      brumal.i3wm.body.modes.notify = {
        key = "${k.alt}+n";
        block.body.bindsym = {
          n = "exec ${notifyToggleScript}/bin/notify-toggle-script";
          f = "exec ${dunstctl} history-pop";
          "${k.shift}+f" = "exec ${dunstctl} close";
          "${k.shift}+c" = "exec ${dunstctl} close-all";
        };
      };
    };
}
