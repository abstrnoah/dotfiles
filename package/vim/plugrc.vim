" Author: Noah <abstractednoah@brumal.org>

" Note: This script does not check whether plugins should be loaded; that should
" be done in vimrc where this is sourced.

" Note: All plugins are declared here, and most of their config goes here. Maps
" go into 'after/maps.vim', unless a plugin has some custom map interface, in
" which case its maps go here.

" PLUGIN CONFIG {{{1

" AUTOSAVE {{{2
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0

" NERDTREE {{{2
let NERDTreeQuitOnOpen = 1
" FIXME: Conceal is causing "^G" to show up in netrw mode (not side mode), need
" to change conceal settings upon opening NERDTree.
let NERDTreeHijackNetrw = 1

" COC {{{2
if has('patch-8.1.1719')
    source ~/.vim/cocrc.vim
    let g:br_configured_coc = 1
endif

" VIMSPECTOR {{{2
let g:vimspector_install_gadgets = [
    \ 'vscode-cpptools',
    \ 'vscode-java-debug'
\]
    " \ 'debugpy',

" CTRLP {{{2
let g:ctrlp_map = ''
let g:ctrlp_cmd = ''
let g:ctrlp_working_path_mode = "ra"
let g:ctrlp_show_hidden = 1
let g:ctrlp_mruf_relative = 1
let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
    \ },
    \ 'fallback': 'find %s -type f'
\ }

" GUTENTAGS {{{2
let g:gutentags_cache_dir = "~/.cache/gutentags"
if has('statusline')
    set statusline^=%{gutentags#statusline()}\|
endif

" TAGBAR {{{2
let g:tagbar_sort = 1

" BULLET {{{2
let g:bullets_checkbox_markers = '    x'
" Use numbers for all levels of enumerated lists.
" This is partly for uniformity, but also because `vim-markdown` makes numbered
" lists pretty, yet does not recognize alphabetic lists so does not make them
" pretty.
let g:bullets_outline_levels = ['num']

" VIM-MARKDOWN {{{2
let g:vim_markdown_override_foldtext = 0
let g:vim_markdown_toc_autofit = 1
" To avoid conflict with bullet plugin, still not ideal TODO.
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
" Folding.
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext = 0
" Because there's a bug where the first H3 folds all the following H3s under it.
let g:vim_markdown_folding_level = 2
" Disable concealing code block delims.
let g:vim_markdown_conceal_code_blocks = 0

" INDENTLINE {{{2
" Note that as it stands, indentLine seems to have control over conceal. So
" conceal color and behavior should be configured here, rather than via `set
" concealcursor`, etc.
let g:indentLine_color_term = "darkgray"
let g:indentLine_char = "┊"
let g:indentLine_concealcursor = ""

" LION {{{2
let g:lion_squeeze_spaces = 1

" SNEAK {{{2
let g:sneak#label = 0

" VIMTEX {{{2
let g:vimtex_compiler_enabled = 1
let g:vimtex_compiler_method = "tectonic"
let g:vimtex_compiler_tectonic = {
    \ 'build_dir' : 'build',
    \ 'options' : [
    \   '--keep-logs',
    \ ],
\}
let g:vimtex_quickfix_autoclose_after_keystrokes = 1
let g:vimtex_fold_enabled = 1
" Vimtex's formatexpr works almost perfectly, except:
" ISSUE: When an environment is given a trailing optional argument. Then 'gqie'
" moves the text inside the environment to start on the same line as the closing
" ']' of the optional argument.
let g:vimtex_format_enabled = 1
" Just, imaps, no.
let g:vimtex_imaps_enabled = 0
" Prohibitively slow.
let g:vimtex_include_search_enabled = 0
" Everything should be indented, even 'document'.
let g:vimtex_indent_ignored_envs = ['seems an empty list breaks vimtex indent']
" EXPERIMENTAL:
let g:vimtex_indent_delims = {'open': ['{', '['], 'close': ['}', ']']}
" Disable a few conceals: 'fancy' conceals \items in a silly looking way;
" 'styles' is unsatisfactory when we have a multiline block of styled text.
let g:vimtex_syntax_conceal = {
    \ 'fancy': 0,
    \ 'styles': 0,
\ }
" Configure the toc.
let g:vimtex_toc_config = {"layers": ['content'], "show_help": 0}


" WORDMOTION {{{2
let g:wordmotion_prefix = '<leader>'
let g:wordmotion_mappings = {'<C-R><C-W>': '<C-R><leader><C-W>'}

" VIMWIKI {{{2
if v:version >= 730
    source ~/.vim/vimwiki_rc.vim
    let g:br_configured_vimwiki = 1
endif

" BUILTIN PLUGINS {{{1

runtime macros/matchit.vim


" VIM-PLUG PLUGINS {{{1

" Automatic installation of vim-plug[^1].
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Declare the plugins.
call plug#begin('~/.cache/vimplug')
    " Must have.
    Plug '907th/vim-auto-save'
    Plug 'Townk/vim-autoclose'
    Plug 'tpope/vim-surround'
    Plug 'wellle/targets.vim'
    if v:version >= 700 && v:version < 800
        Plug 'ludovicchabant/vim-gutentags', {'commit': '3314afd'}
    elseif v:version >= 800
        Plug 'ludovicchabant/vim-gutentags'
    endif
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'tpope/vim-repeat'
    " Should have.
    Plug 'lervag/vimtex', {'for': 'tex'}
    Plug 'justinmk/vim-sneak'
    Plug 'tpope/vim-eunuch'
    Plug 'dkarter/bullets.vim'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'tommcdo/vim-lion'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    " Fancy and useful extras.
    Plug 'preservim/nerdtree'
    Plug 'preservim/tagbar'
    Plug 'tpope/vim-abolish'
    if v:version >= 802
        Plug 'chaoren/vim-wordmotion'
    endif
    " Frills.
    Plug 'Yggdroot/indentLine'
    " These ones are on thin ice.
    if exists('g:br_configured_coc')
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
    endif
    Plug 'honza/vim-snippets'
    Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
    " Filetype.
    Plug 'mboughaba/i3config.vim'
    " Theme.
    Plug 'abstractednoah/vim-colors-solarized', {'branch': 'develop'}
    " Overpowered, these should probably be their own tool but here we are.
    if exists('g:br_configured_vimwiki')
        Plug 'vimwiki/vimwiki'
    endif
    " Deprecated.
    " Plug 'puremourning/vimspector'
    " Plug 'abstractednoah/vim-markdownfootnotes', {'branch': 'develop'}
    " Apparently the "mma" filetype is a builtin; this might be more up to date?
    " Plug 'arnoudbuzing/wolfram-vim'
call plug#end()



" NOTES {{{1
" [^1]: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
