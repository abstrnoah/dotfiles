{ library, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      inputs',
      ...
    }:
    let
      inherit (inputs'.nixvim.legacyPackages) makeNixvimWithModule;
      inherit (library) mapAttrsToListRecursiveCond length elemAt;

      genKeymaps =
        common: modeMapSpec:
        mapAttrsToListRecursiveCond (path: value: length path < 2) (
          path: value:
          common
          // {
            mode = elemAt path 0;
            key = elemAt path 1;
          }
          // value
        ) modeMapSpec;

      tabstop = 2;
      resizeWidth = "10";
      resizeHeight = "5";

      nixvimModule =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {

          viAlias = true;
          vimAlias = true;

          colorschemes.nightfox.enable = true;
          highlightOverride.CursorColumn.bold = true;

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
          opts.updatetime = 300;
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
          opts.tabstop = tabstop; # One tab = tabstop spaces.
          opts.softtabstop = tabstop;
          opts.shiftwidth = 0; # 'shiftwidth=0' means fallback to 'tabstop'.
          opts.smarttab = true;
          opts.timeoutlen = 500;

          globals.mapleader = " ";
          globals.maplocalleader = " ";

          extraFiles."autoload/brumal.vim".text = ''
            " brumal#multiSearch(case_sensitive, word_boundaries, tokens...)
            "   Produce a pattern for searching for tokens across lines and non-word
            "   characters, with the option of case sensitivity and of adding '\<','\>' word
            "   boundaries around the tokens. When not word_boundaries, also search across
            "   underscores. Inspired by [^1]. Note that this isn't super robust, as the
            "   behavior of the returned pattern might depend on your settings. We assume
            "   'noignorecase', 'nosmartcase', and 'magic'.
            function brumal#multiSearch(case_sensitive, word_boundaries, ...) abort
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
            command = "let @/ = brumal#multiSearch(0, <bang>0, <f-args>) | normal! /<C-R>/<CR>";
            bang = true;
            nargs = "*";
            complete = "tag";
          };
          userCommands.SB = {
            command = "let @/ = brumal#multiSearch(0, <bang>0, <f-args>) | normal! ?<C-R>/<CR>";
            bang = true;
            nargs = "*";
            complete = "tag";
          };

          extraPlugins =
            let
              p = pkgs.vimPlugins;
            in
            [
              p.vim-auto-save
              p.targets-vim
              p.vim-gutentags
              p.ctrlp-vim
              p.vim-sneak
              p.vim-eunuch
              p.vim-wordmotion
              (pkgs.vimUtils.buildVimPlugin {
                name = "wiki.vim";
                src = pkgs.fetchFromGitHub {
                  owner = "abstrnoah";
                  repo = "wiki.vim";
                  rev = "1f82f8a2fee6686e80386689b3ec67e97b0a8768";
                  hash = "sha256-3rqpMyp0UtJ3USWYaQHGIF3l8PKvGXoZ0Ii2ptCgGK0=";
                };
              })
              p.vim-qf
              p.vim-exchange
              p.gv-vim
              p.vim-peekaboo
              (pkgs.vimUtils.buildVimPlugin {
                name = "lists.vim";
                src = pkgs.fetchFromGitHub {
                  owner = "abstrnoah";
                  repo = "lists.vim";
                  rev = "1483c87b878cc4ef8684d83f76997deae5989437";
                  hash = "sha256-vlnUtBZMJEI/nme0baQ7HrEjg9RHGqqgiPAW2daqXnU=";
                };
              })
              p.vim-gitgutter
            ];

          dependencies.ctags.enable = true;

          plugins.repeat.enable = true;
          plugins.commentary.enable = true;
          plugins.fugitive.enable = true;
          plugins.abolish.enable = true;
          plugins.vim-surround.enable = true;

          # TODO learn
          plugins.cmp = {
            enable = true;
            autoEnableSources = true;
            settings.source = [
              { name = "buffer"; }
              { name = "path"; }
              { name = "nvim_lsp"; }
              { name = "tmux"; }
            ];
          };

          plugins.treesitter = {
            enable = true;
            highlight.enable = true;
            indent.enable = true;
            grammarPackages =
              let
                p = pkgs.vimPlugins.nvim-treesitter.builtGrammars;
              in
              [
                p.bash
                p.json
                p.lua
                p.make
                p.markdown
                p.markdown_inline
                p.nix
                p.regex
                p.toml
                p.vim
                p.vimdoc
                p.xml
                p.yaml
              ];
          };

          globals.auto_save = 1;
          globals.auto_save_in_insert_mode = 0;

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
            quickfix_mode = 0;
          };

          globals.ctrlp_map = "";
          globals.ctrlp_cmd = "";
          globals.ctrlp_working_path_mode = "ra";
          globals.ctrlp_show_hidden = 1;
          globals.ctrlp_mruf_relative = 1;
          globals.ctrlp_user_command = {
            types."1" = [
              ".git"
              "cd %s && ${pkgs.git}/bin/git ls-files -co --exclude-standard"
            ];
            fallback = "${pkgs.findutils}/bin/find %s -type f";
          };

          globals.gutentags_cache_dir = "~/cache/gutentags";

          globals.wiki_root = "~/store/notes/wiki";
          globals.wiki_completion_case_sensitive = 0;
          globals.wiki_mappings_prefix = "<leader>n";
          globals.wiki_filetypes = [
            "md"
            "tree"
            "wiki"
          ];
          globals.wiki_journal = {
            name = "";
          };
          globals.wiki_link_extension = "";
          globals.wiki_map_text_to_link = lib.nixvim.mkRaw "function(text) return { text, text } end";

          globals.surround_no_insert_mappings = 1;

          globals.qf_auto_quit = 0;

          globals.gitgutter_set_sign_backgrounds = 0;

          files."after/ftplugin/qf.lua" = {
            localOpts.wrap = false;
            keymaps =
              genKeymaps
                {
                  options.buffer = true;
                  options.silent = true;
                }
                {
                  n.q.action = ":q<cr>";
                  n."<cr>".action = "<cr>:cclose<cr>:lclose<cr>";
                };
          };

          extraFiles."after/ftplugin/tex.vim".text = ''
            let b:surround_{char2nr('$')} = "\\(\r\\)"
          '';

          keymaps = genKeymaps { } {
            n."<leader>m" = {
              options.expr = true;
              action = ''":'".nr2char(getchar())." m .<cr>"'';
            };
            n."<leader>M" = {
              options.expr = true;
              action = ''":'".nr2char(getchar())." m -1<cr>"'';
            };
            n."<leader>ep".action = ":CtrlPMixed<cr>";
            n."<leader>eb".action = ":CtrlPBuffer<cr>";
            n."<leader>s".action = ":set spell!<cr>";
            n."<esc>" = {
              options.silent = true;
              action = ":nohlsearch<cr><esc>";
            };
            n."<leader>/".action = ":S<space>";
            n."<leader>?".action = ":SB<space>";
            ""."f".action = "<plug>Sneak_f";
            ""."F".action = "<plug>Sneak_F";
            ""."t".action = "<plug>Sneak_t";
            ""."T".action = "<plug>Sneak_T";
            ""."<leader>y".action = ''"+y'';
            ""."<leader>p".action = ''"+p'';
            ""."<leader>P".action = ''"+P'';
            n."<c-w><c-h>".action = ":vertical resize -${resizeWidth}<cr";
            n."<c-w><c-l>".action = ":vertical resize +${resizeWidth}<cr";
            n."<c-w><c-j>".action = ":resize -${resizeHeight}<cr";
            n."<c-w><c-k>".action = ":resize +${resizeHeight}<cr";
            n."<leader>l".action = ":set list!<cr>";
            i."<c-u>".action = "<c-g>u<c-u>";
            i."<c-w>".action = "<c-g>u<c-w>";
          };
        };

    in
    {
      packages.nvim = makeNixvimWithModule {
        inherit pkgs;
        module = nixvimModule;
      };
      overlayAttrs.nvim = self'.packages.nvim;
    };

  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.variables.EDITOR = "vim";
      brumal.profile.packages = [ pkgs.nvim ];
    };
}
# pkgs.universal-ctags # TODO
# TODO luaify autoload
