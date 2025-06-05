{
  flake.modules.brumal.vim =
    {
      config,
      lib,
      library,
      packages,
      ...
    }:
    let
      nvim-to-vim-symlink = library.storeSymlink "nvim-as-vim" "${packages.neovim}/bin/nvim" "/bin/vim";
      vim-plug-symlink =
        library.storeSymlink "vim-plug" "${packages.vim-plug}/plug.vim"
          "/home/me/.vim/autoload/plug.vim";
      vim-rc = library.storeLegacyDotfiles "vim";
    in
    lib.mkMerge [
      (lib.mkIf (config.distro == "nixos") {
        nixos.environment.systemPackages = [ packages.neovim ];
      })
      (lib.mkIf (config.distro == "debian") {
        legacyDotfiles = [ packages.neovim ];
      })
      {
        legacyDotfiles = [
          vim-rc
          nvim-to-vim-symlink
          vim-plug-symlink
        ];
      }
    ];
}
