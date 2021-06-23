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
source ~/.vim/cocrc.vim

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
        Plug 'ludovicchabant/vim-gutentags', {'branch': 'vim7'}
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
    Plug 'chaoren/vim-wordmotion'
    " Frills.
    Plug 'Yggdroot/indentLine'
    Plug 'abstractednoah/vim-markdownfootnotes', {'branch': 'develop'}
    " These ones are on thin ice.
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'honza/vim-snippets'
    Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
    " Theme.
    Plug 'altercation/vim-colors-solarized'
    " Deprecated.
    " Plug 'puremourning/vimspector'
call plug#end()



" NOTES {{{1
" [^1]: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
