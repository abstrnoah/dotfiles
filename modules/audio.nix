{
  brumal.nixpkgs.allowUnfree = [ "spotify" ];
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      security.rtkit.enable = true;
      services.pipewire.enable = true;
      brumal.profile.packages = [
        pkgs.spotify
        pkgs.catt
      ];
    };
  flake.nixosModules.gui =
    { pkgs, config, ... }:
    let
      k = config.brumal.i3wm.keys;
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
      volume-step = "5%";
      volume-up = "${wpctl} set-volume @DEFAULT_SINK@ ${volume-step}+";
      volume-down = "${wpctl} set-volume @DEFAULT_SINK@ ${volume-step}-";
      volume-mute = "${wpctl} set-mute @DEFAULT_SINK@ toggle";
      volume-mute-true = "${wpctl} set-mute @DEFAULT_SINK@ 1";
      mic-mute = "${wpctl} set-mute @DEFAULT_SOURCE@ toggle";
      spotifycli = "${pkgs.spotify-cli-linux}/bin/spotifycli";
    in
    {
      # Directives because global (not under k.mod) keys
      # Reference: https://wiki.linuxquestions.org/wiki/XF86_keyboard_symbols
      # We bypass body.bindsym to avoid mod+ leader (cringe I know TODO FIXME)
      brumal.i3wm.body.directives = [
        "bindsym XF86AudioRaiseVolume exec ${volume-up}"
        "bindsym XF86AudioLowerVolume exec ${volume-down}"
        "bindsym XF86AudioMute exec ${volume-mute}"
        "bindsym XF86AudioMicMute exec ${mic-mute}"
        "bindsym XF86AudioPrev exec ${spotifycli} --prev"
        "bindsym XF86AudioPlay exec ${spotifycli} --playpause"
        "bindsym XF86AudioPause exec ${spotifycli} --playpause"
        "bindsym XF86AudioNext exec ${spotifycli} --next"
      ];
      brumal.i3wm.body.modes.audio = {
        key = "a";
        hint = "[h]󰒭 [l]󰒮 [k]󰝝 [j]󰝞 [m]󰝟 [space]󰐎 ";
        block.body.bindsym = {
          k = "exec ${volume-up}";
          j = "exec ${volume-down}";
          m = "exec ${volume-mute}";
          h = "exec ${spotifycli} --prev";
          l = "exec ${spotifycli} --next";
          space = "exec ${spotifycli} --playpause";
        };
      };

      systemd.user.services.volume-mute = {
        script = volume-mute-true;
        wantedBy = [
          "lock.target"
          "shutdown.target"
          "sleep.target"
        ];
        before = [
          "lock.target"
          # TODO Is it still working inconsistently on shutdown?
          "shutdown.target" # This should be unnecessary because DefaultDependencies
          "sleep.target"
        ];
      };
    };
}
