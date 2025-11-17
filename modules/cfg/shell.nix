{
  flake.nixosModules.base.brumal.bash = {
    inputrc = ''
      set bell-style none
      set editing-mode vi
      set keymap vi
    '';
  };
}
