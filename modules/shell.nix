{
  flake.nixosModules.base = {
    brumal.bash = {
      inputrc = ''
        set bell-style none
        set editing-mode vi
        set keymap vi
      '';
      profile = ''
        ttdl-all() {
            ttdl list --all --completed none "$@"
        }

        ttdl-unsorted() {
            ttdl-all --pri none "$@"
        }

        ttdl-now() {
            ttdl list --pri x+ "$@"
        }
      '';

    };
    programs.fzf.keybindings = true;
    programs.fzf.fuzzyCompletion = true;
  };
}
