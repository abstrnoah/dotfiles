{
  perSystem =
    { library, packages, ... }:
    {
      packages.nvim-to-vim-symlink =
        library.storeSymlink "nvim-as-vim" "${packages.neovim}/bin/nvim"
          "/bin/vim";
      legacyDotfiles.vim-plug-symlink =
        library.storeSymlink "vim-plug" "${packages.vim-plug}/plug.vim"
          "/home/me/.vim/autoload/plug.vim";
      legacyDotfiles.vim = library.storeLegacyDotfiles "vim";
    };
  legacyConfig.machines.coyote.packages = [
    "nvim-to-vim-symlink"
    "neovim"
  ];
  legacyConfig.machines.coyote.legacyDotfiles = [
    "vim"
    "vim-plug-symlink"
  ];
}
