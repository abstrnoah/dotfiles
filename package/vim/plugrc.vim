" Author: Noah <abstractednoah@brumal.org>

" Note: This script does not check whether plugins should be loaded; that should
" be done in vimrc where this is sourced.

" Note: All plugins are declared here, and most of their config goes here. Maps
" go into 'after/maps.vim', unless a plugin has some custom map interface, in
" which case its maps go here.

" SETUP {{{1

" A dicionary declaring plugins. The schema is:
"   {string that vimplug recognises as a plugin name:
"       [list of dictionaries for each version of plugin, to be tried first to
"        last until a supported version is found or end reached
"           {"spec": dictionary that can be passed to a 'Plug' command,
"            "supported": a function that takes no arguments, returns 1 if the
"                         version is supported, and 0 otherwise}]}
" An empty list implies that vimplug should do its default thing always.
" An omitted "spec" implies no spec, vimplug should do its default thing.
" An omitted "supported" implies the version is always supported.
let g:br_plugs = {
    \ "907th/vim-auto-save": [],
    \ "Townk/vim-autoclose": [],
    \ "tpope/vim-surround": [],
    \ "wellle/targets.vim": [],
    \ "ludovicchabant/vim-gutentags": [
        \ {
            \ "spec": {"commit": "3314afd"},
            \ "supported": {-> v:version >= 700 && v:version < 800}
        \ },
        \ {
            \ "supported": {-> v:version >= 800}
        \ }
    \ ],
    \ "ctrlpvim/ctrlp.vim": [],
    \ "tpope/vim-repeat": [],
    \ "lervag/vimtex": [{"spec": {"for": "tex"}}],
    \ "justinmk/vim-sneak": [],
    \ "tpope/vim-eunuch": [],
    \ "dkarter/bullets.vim": [],
    \ "dhruvasagar/vim-table-mode": [],
    \ "tommcdo/vim-lion": [],
    \ "tpope/vim-commentary": [],
    \ "tpope/vim-fugitive": [],
    \ "preservim/nerdtree": [],
    \ "preservim/tagbar": [],
    \ "tpope/vim-abolish": [],
    \ "chaoren/vim-wordmotion": [{"supported": {-> v:version >= 802}}],
    \ "Yggdroot/indentLine": [],
    \ "neoclide/coc.nvim": [
        \ {
            \ "spec": {"tag": "v0.0.81"},
            \ "supported": {-> has("patch-8.1.1719")}
        \ }
    \ ],
    \ "honza/vim-snippets": [],
    \ "plasticboy/vim-markdown": [{"spec": {'for': 'markdown'}}],
    \ "mboughaba/i3config.vim": [],
    \ "abstractednoah/vim-colors-solarized": [{"spec": {"branch": "develop"}}],
    \ "vimwiki/vimwiki": [{"supported": {-> v:version >= 730}}],
    \ "junegunn/vim-plug": [],
    \ "Konfekt/FastFold": [],
    \ "fmoralesc/vim-pad": [
        \ {
            \ "spec": {"branch": "devel"},
            \ "supported": {->
                \ v:version >= 740
                \ && (has("python") || has("python3"))
                \ && has("conceal")
            \ }
        \ }
    \ ],
    \ "tpope/vim-fireplace": [],
    \ "abstractednoah/vim-fireplace": [],
    \ "romainl/vim-qf": [],
    \ "tommcdo/vim-exchange": [],
    \ "vim-scripts/utl.vim": [],
    \ "vim-scripts/paredit.vim": [],
    \ "abstractednoah/paredit.vim": [],
    \ "junegunn/gv.vim": [],
    \ "junegunn/vim-peekaboo": [],
    \ "fcpg/vim-showmap": [],
    \ "lervag/wiki.vim": [{"supported": {-> v:version >= 801}}],
    \ "abstractednoah/wiki.vim": [
        \ {
            \ "supported": {-> v:version >= 801},
            \ "spec": {"branch": "feat-mappings-prefix"}
        \ }
    \ ],
    \ "abstractednoah/lists.vim": [],
\ }

" A list of keys to 'g:br_plugs'.
let g:br_plugs_active = [
    \ "907th/vim-auto-save",
    \ "tpope/vim-surround",
    \ "wellle/targets.vim",
    \ "ludovicchabant/vim-gutentags",
    \ "ctrlpvim/ctrlp.vim",
    \ "tpope/vim-repeat",
    \ "lervag/vimtex",
    \ "justinmk/vim-sneak",
    \ "tpope/vim-eunuch",
    \ "dhruvasagar/vim-table-mode",
    \ "tpope/vim-commentary",
    \ "tpope/vim-fugitive",
    \ "preservim/nerdtree",
    \ "preservim/tagbar",
    \ "tpope/vim-abolish",
    \ "chaoren/vim-wordmotion",
    \ "Yggdroot/indentLine",
    \ "neoclide/coc.nvim",
    \ "plasticboy/vim-markdown",
    \ "mboughaba/i3config.vim",
    \ "abstractednoah/vim-colors-solarized",
    \ "abstractednoah/wiki.vim",
    \ "junegunn/vim-plug",
    \ "abstractednoah/vim-fireplace",
    \ "romainl/vim-qf",
    \ "tommcdo/vim-exchange",
    \ "Konfekt/FastFold",
    \ "vim-scripts/utl.vim",
    \ "abstractednoah/paredit.vim",
    \ "junegunn/gv.vim",
    \ "junegunn/vim-peekaboo",
    \ "abstractednoah/lists.vim",
\ ]

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
if brumal#main#plug_supported("neoclide/coc.nvim", g:br_plugs)
    source ~/.vim/cocrc.vim
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
" Disable concealing code block delims. TODO why did I disable this?
" let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
let g:vim_markdown_no_defauly_key_mappings = 1

" INDENTLINE {{{2
" Note that as it stands, indentLine seems to have control over conceal. So
" conceal color and behavior should be configured here, rather than via `set
" concealcursor`, etc.
let g:indentLine_color_term = "darkgray"
let g:indentLine_char = "┊"
let g:indentLine_concealcursor = ""
let g:indentLine_fileTypeExclude = ["clojure"]

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
let g:vimtex_quickfix_mode = 0
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
let g:vimtex_indent_delims = {'open': ['{',], 'close': ['}',]}
let g:vimtex_indent_on_ampersands = 0
let g:vimtex_indent_tikz_commands = 0
" Disable a few conceals: 'fancy' conceals \items in a silly looking way;
" 'styles' is unsatisfactory when we have a multiline block of styled text.
let g:vimtex_syntax_conceal_disable = 1
" let g:vimtex_syntax_conceal = {
"     \ 'fancy': 0,
"     \ 'styles': 0,
" \ }
" Configure the toc.
let g:vimtex_toc_config = {"layers": ['content'], "show_help": 0}


" WORDMOTION {{{2
let g:wordmotion_prefix = '<leader>'
let g:wordmotion_mappings = {'<C-R><C-W>': '<C-R><leader><C-W>'}

" WIKI.VIM {{{2
let g:wiki_root = "~/repository/notes/wiki"
let g:wiki_index_name = "scratch"
let g:wiki_completion_case_sensitive = 0
let g:wiki_mappings_prefix = g:br_leader_note
let g:wiki_filetypes = ['md', 'wiki']

let g:wiki_link_target_type = "md"
let g:wiki_link_extension = "." . g:wiki_link_target_type
let g:wiki_map_text_to_link = "BrWikiMapTextToLink"
let g:wiki_map_create_page = "BrWikiMapCreatePage"

let g:wiki_fzf_pages_opts = '--preview "bat {1}"'

function BrWikiMapTextToLink(text) abort
    return [substitute(tolower(a:text), '[^a-z0-9_-]', '_', 'g'), a:text]
endfunction

function BrWikiMapCreatePage(name) abort
    if empty(a:name)
        if exists("*strftime")
            return strftime('%Y-%m-%d_%H-%M-%S_%z')
        else
            throw "Missing dependency: strftime()"
        endif
    else
        return BrWikiMapTextToLink(a:name)[0]
    endif
endfunction

" LISTS.VIM {{{2
let g:lists_filetypes = ['md', 'markdown', 'wiki', 'vimwiki', 'gitcommit']
let g:lists_maps_prefix = g:br_leader_note

" VIM-PAD {{{2
let g:pad#dir = "~/repository/notes/vim-pad"
let g:pad#local_dir = "notes"
let g:pad#default_format = "markdown"
let g:pad#search_backend = "ag"
let g:pad#rename_files = 0
let g:pad#open_in_split = 0

let g:pad#maps#list = g:br_leader_note . "l"
let g:pad#maps#new = g:br_leader_note . "c"
let g:pad#maps#search = g:br_leader_note . "f"
let g:pad#maps#incsearch = "F"
let g:pad#maps#newsilent = ""

" PAREDIT {{{2
let g:paredit_leader = g:br_leader_sexp
let g:paredit_shortmaps = 0

" FIREPLACE {{{2
let g:fireplace_eval_opts = {
    \ "nrepl.middleware.print/quota": 5000,
\ }

" SURROUND {{{2
let g:surround_no_insert_mappings = 1

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
call brumal#main#declare_plugs(g:br_plugs, g:br_plugs_active)
call plug#end()



" NOTES {{{1
" [^1]: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
