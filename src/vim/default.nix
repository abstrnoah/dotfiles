config@{ bundle, store-dotfiles }:
packages@{ vim, curl, fzf, vim-plug }:

bundle {
    name = "vim";
    packages = packages // {
        vim-rc = store-dotfiles "vim";
    };
}
