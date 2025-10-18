{
  flake.nixosModules.base =
    {
      library,
      utilities,
      config,
      pkgs,
      ...
    }:
    let
      env = config.brumal.env;
      inherit (utilities) storeSymlink storeLegacyDotfiles;
      nvimAsVimP = storeSymlink "nvim-as-vim" "${pkgs.neovim}/bin/nvim" "/bin/vim";
      vimPlugP =
        storeSymlink "vim-plug" "${pkgs.vimPlugins.vim-plug}/plug.vim"
          "${env.HOME}/.vim/autoload/plug.vim";
      vimRcP = storeLegacyDotfiles "vim";
    in
    {
      environment.systemPackages = [ pkgs.vim ];
      brumal.profile.packages = [
        nvimAsVimP
        vimPlugP
        vimRcP
      ];
    };
}
