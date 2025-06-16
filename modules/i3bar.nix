{
  flake.modules.nixos.wm =
    { packages, ... }:
    {
      brumal.cfg.i3wm.body.blocks.bar.body = {
        directives = [
          "status_command ${packages.i3status}"
          "mode dock"
          "position bottom"
          "tray_output primary"
          "tray_padding 0"
        ];
      };
    };
}
