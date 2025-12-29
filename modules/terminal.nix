{
  flake.nixosModules.gui =
    { config, pkgs, ... }:
    let
      k = config.brumal.i3wm.keys;
      bin = config.brumal.files.bin;
    in
    {
      brumal.i3wm.body.bindsym.${k.enter} = ''exec "i3-sensible-terminal"'';
      brumal.i3wm.body.bindsym."${k.alt}+${k.enter}" = ''exec "BR_NOMUX=1 i3-sensible-terminal"'';
    };
}
