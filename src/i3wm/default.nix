config@{ bundle, write-text, systemd-user-units-path, wttrin-cache-path
, write-shell-app, escape-shell-arg, store-dotfiles }:
packages@{ i3wm, curl }:

let
  wttrin-service = write-text {
    name = "fetch-wttrin.service";
    destination = systemd-user-units-path + "/fetch-wttrin.service";
    text = ''
      [Unit]
      Description=Fetch weather from wttr.in

      [Service]
      Type=oneshot
      ExecStart=${wttrin-script}/bin/fetch-wttrin
    '';
  };
  wttrin-timer = write-text {
    name = "fetch-wttrin.timer";
    destination = systemd-user-units-path + "/fetch-wttrin.timer";
    text = ''
      [Unit]
      Description=Fetch weather from wttr.in timer

      [Timer]
      OnBootSec=15min
      OnUnitActiveSec=15min

      [Install]
      WantedBy=timers.target
    '';
  };
  wttrin-script = write-shell-app {
    name = "fetch-wttrin";
    runtimeInputs = [ curl ];
    text = ''
      location="$(cat "$HOME/.default_location" || echo "")"
      curl -s "https://wttr.in/$location?m&format=%c🌡%t+💧%h+🍃%w" \
        > ${escape-shell-arg wttrin-cache-path}
    '';
  };

in bundle {
  name = "i3wm";
  packages = {
    inherit i3wm wttrin-service wttrin-timer;
    rc = store-dotfiles "i3wm";
  };
}
