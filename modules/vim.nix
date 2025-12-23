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
      vimRcP = storeLegacyDotfiles "vim";
    in
    {
      environment.systemPackages = [ pkgs.neovim ];
      environment.variables.EDITOR = "vim";
      brumal.profile.packages = [
        nvimAsVimP
        vimRcP
        pkgs.universal-ctags
      ];
      brumal.files.home.".vim/autoload/plug.vim".source = "${pkgs.vimPlugins.vim-plug}/plug.vim";
    };
}
