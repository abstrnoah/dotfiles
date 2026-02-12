{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      brumal.files.bin = {
        watchdumb.text = ''
          if [ "$#" -lt 2 ]; then
            exit 1
          fi
          interval="$1"
          shift
          while true; do
            clear
            date +'[%a %Y-%m-%d %H:%M:%S %Z]'
            echo "> $*"
            "$@"
            sleep "$interval"
          done
        '';
        bropen.text = ''
          for f in "$@"; do
            xdg-open "$f" &
            disown -h
          done
        '';
        base10To36.text = ''
          if [ "$#" -ne 1 ]; then
            exit 1
          fi

          base36bet=({0..9} {A..Z})

          for i in $(${pkgs.bc}/bin/bc <<< "ibase=10; obase=36; $1"); do
            echo -n "''${base36bet[$i]}"
          done
        '';
      };
    };
}
