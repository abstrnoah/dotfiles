{
  flake.nixosModules.base =
    { library, config, ... }:
    let
      inherit (library) mkAfter;
      bin = config.brumal.files.bin;
    in
    {
      brumal.bash = {
        inputrc = ''
          set bell-style none
          set editing-mode vi
          set keymap vi
        '';
        rc = ''
          alias T='${bin.gomux.source}'
        '';
      };
      programs.fzf.keybindings = true;
      programs.fzf.fuzzyCompletion = true;

      brumal.files.bin.oops.text = ''
        echo "$1" >/dev/stderr
        exit 1
      '';
    };
}
