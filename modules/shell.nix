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
          alias T='${bin.tmux-go-last.source}'
        '';
      };
      programs.fzf.keybindings = true;
      programs.fzf.fuzzyCompletion = true;
    };
}
