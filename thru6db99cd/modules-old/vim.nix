{
  flake.modules.brumal.vim =
    {
      config,
      packages,
      library,
      mkCases,
      ...
    }:
    let
      nvim-to-vim-symlink = library.storeSymlink "nvim-as-vim" "${packages.neovim}/bin/nvim" "/bin/vim";
      vim-plug-symlink =
        library.storeSymlink "vim-plug" "${packages.vim-plug}/plug.vim"
          "/home/me/.vim/autoload/plug.vim";
      vim-rc = library.storeLegacyDotfiles "vim";
    in
    mkCases config.distro {
      nixos.nixos.environment.systemPackages = [ packages.neovim ];
      "*" = {
        userPackages = { inherit (packages) neovim; };
        legacyDotfiles = { inherit vim-rc nvim-to-vim-symlink vim-plug-symlink; };
      };
    };
}
