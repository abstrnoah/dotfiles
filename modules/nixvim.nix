{
  perSystem =
    { pkgs, inputs', ... }:
    let
      inherit (inputs'.nixvim.legacyPackages) makeNixvimWithModule;

      nixvimModule = {pkgs, ...}: {

        colorschemes.nightfox.enable = true;

        opts.cmdheight = 2;
        opts.list = true;
        opts.listchars = "tab:<->,trail:_,precedes:<,extends:>";
        opts.linebreak = true;
        opts.breakindent = true;
        extraConfigLua = ''
          vim.opt.matchpairs:append("<:>")
        '';
        opts.number = true;
        opts.scrolloff = 3;
        opts.signcolumn = "yes";
        opts.statusline = "%<%f %m%r%y%=(%l/%L %P, %c)";
        opts.cursorline = true;
        opts.cursorcolumn = true;
        opts.spelllang = "en_gb";
        opts.spelloptions = "camel";
        opts.spellcapcheck = "";
        opts.splitbelow = true;
        opts.splitright = true;
        opts.swapfile = false;
        opts.expandtab = true;
        opts.tabstop = 4; # One tab = four spaces.
        opts.softtabstop = 4;
        opts.shiftwidth = 0; # 'shiftwidth=0' means fallback to 'tabstop'.
        opts.smarttab = true;
        opts.timeoutlen = 500;

        globals.mapleader = " ";
        globals.maplocalleader = " ";

        extraFiles."autoload/brumal.vim".text = ''
          " brumal#main#multiSearch(case_sensitive, word_boundaries, tokens...)
          "   Produce a pattern for searching for tokens across lines and non-word
          "   characters, with the option of case sensitivity and of adding '\<','\>' word
          "   boundaries around the tokens. When not word_boundaries, also search across
          "   underscores. Inspired by [^1]. Note that this isn't super robust, as the
          "   behavior of the returned pattern might depend on your settings. We assume
          "   'noignorecase', 'nosmartcase', and 'magic'.
          function brumal#main#multiSearch(case_sensitive, word_boundaries, ...) abort
              if a:0 > 0
                  " Search for tokens delimited by the following separators:
                  " \_W non-word including end-of-line.
                  " _ underscores.
                  let l:sep = '\(\_W\|_\)\+'
                  " Note that word_boundaries overrides the '_' separator.
                  if a:word_boundaries
                      let l:words = map(deepcopy(a:000), '"\\<" . v:val . "\\>"')
                  else
                      let l:words = a:000
                  endif
                  return join(l:words, l:sep) . ((a:case_sensitive) ? "" : '\c')
              else
                  return '''
              endif
          endfunction "
        '';
        userCommands.S = {
          command = "let @/ = brumal#main#multiSearch(0, <bang>0, <f-args>) | normal! /<C-R>/<CR>";
          bang = true;
          nargs = "*";
          complete = "tag";
        };
        userCommands.SB = {
          command = "let @/ = brumal#main#multiSearch(0, <bang>0, <f-args>) | normal! ?<C-R>/<CR>";
          bang = true;
          nargs = "*";
          complete = "tag";
        };

        extraPlugins = [
          pkgs.vimPlugins.vim-auto-save
          pkgs.vimPlugins.targets-vim
          pkgs.vimPlugins.vim-gutentags
          pkgs.vimPlugins.ctrlp-vim
        ];
        plugins.repeat.enable = true;

        plugins.vimtex.enable = true;
        plugins.vimtex.settings = {
          compiler_enabled = true;
          compiler_method = "tectonic";
          compiler_tectonic = {
            out_dir = "out";
            options = [ "--keep-logs" ];
          };
          imaps_enabled = false;
          include_search_enabled = false;
          indent_ignored_envs = [ "seems an empty list breaks vimtex indent" ];
          indent_delims = {
            open = [ "{" ];
            close = [ "}" ];
          };
          indent_on_ampersands = false;
          indent_tikz_commands = false;
        };

      };

    in
    {
      packages.nvim = makeNixvimWithModule {
        inherit pkgs;
        module = nixvimModule;
      };
    };
}
# pkgs.universal-ctags # TODO
# TODO updatetime=300
# TODO luaify autoload
