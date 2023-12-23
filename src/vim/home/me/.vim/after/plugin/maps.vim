" Note: We attempt to sort maps by mnemonic, not necessarily by plugin unless a
" plugin occupies its own niche.

" SETUP {{{1

" Clear previous leader mappings.
nmap <leader> <nop>

" Disable various dumb keys.
nnoremap <silent> <ESC>OA <NOP>
nnoremap <silent> <ESC>OB <NOP>
nnoremap <silent> <ESC>OC <NOP>
nnoremap <silent> <ESC>OD <NOP>
inoremap <silent> <ESC>OA <NOP>
inoremap <silent> <ESC>OB <NOP>
inoremap <silent> <ESC>OC <NOP>
inoremap <silent> <ESC>OD <NOP>
inoremap <silent> <ESC>OD <NOP>
inoremap <silent> <DEL> <NOP>

" Disable ex-mode keys.
map Q <nop>
" Doesn't seem to work TODO.
"map gQ <nop>

" GENERAL {{{1
" TODO Flatten the organization of this file.

" Briefly visually highlight "block" where the cursor is, return to original
" location. See 'help vib'.
" nnoremap <leader>. m[vib:<c-u>sleep 350m<cr>`[

" Move by mark.
" Move marked line below.
nnoremap <expr> <leader>m ":'".nr2char(getchar())." m .<cr>"
" Move marked line above.
nnoremap <expr> <leader>M ":'".nr2char(getchar())." m -1<cr>"

" EXPLORE {{{1
execute "nnoremap" g:br_leader_nav."m" ":TagbarOpenAutoClose<CR>"
execute "nnoremap" g:br_leader_nav."n" ":call brumal#main#nerdtree()<cr>"
execute "nnoremap" g:br_leader_nav."p" ":CtrlPMixed<cr>"
execute "nnoremap" g:br_leader_nav."b" ":CtrlPBuffer<cr>"
execute "nnoremap" g:br_leader_nav."l" ":CtrlPLine<cr>"
execute "nnoremap" g:br_leader_nav."t" ":CtrlPTag<cr>"

" WIKI
execute "nnoremap" g:br_leader_note."p" ":WikiFzfPages<cr>"

" UTL <url:vimhelp:utl> {{{1
nnoremap <leader><cr> :Utl<cr>
xnoremap <leader><cr> :<c-u>Utl openLink visual<cr>

" SPELL {{{1
if has('syntax')
    nmap <leader>s :set spell!<cr>
endif

" SEARCH {{{1

" Unhighlight on <ESC>.
nnoremap <silent> <ESC> :nohlsearch<CR><ESC>

nnoremap <leader>/ :S<space>
nnoremap <leader>? :SB<space>
execute "nnoremap" g:br_leader_bang."/" ":S!<space>"
execute "nnoremap" g:br_leader_bang."?" ":SB!<space>"

" Original newlines.
execute "nnoremap" g:br_leader_bang."o" "o"
execute "nnoremap" g:br_leader_bang."O" "O"

" MOTIONS {{{1
if exists('g:loaded_sneak_plugin')
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
endif

" See plugrc.vim for wordmotion config.

" CLIPBOARD {{{1
if has('clipboard')
    map <leader>y "+y
    map <leader>p "+p
    map <leader>P "+P
    " Unformattedly yank operators.
    nnoremap <leader>Y :set operatorfunc=brumal#main#yankUnformattedOperator<cr>g@
    nnoremap <leader>YY :set operatorfunc=brumal#main#yankUnformattedOperator<cr>g@_
    xnoremap <leader>Y :<c-u>call brumal#main#yankUnformattedOperator("visual")<cr>
endif

" FORMAT {{{1
nnoremap Q :set operatorfunc=brumal#main#unformatOperator<cr>g@
nnoremap QQ :set operatorfunc=brumal#main#unformatOperator<cr>g@_
xnoremap Q :<c-u>call brumal#main#unformatOperator("visual")<cr>

" TABLE-MODE {{{1

nnoremap <leader>tm :call brumal#main#toggleTableMode()<cr>

" QUICKFIX {{{1
execute 'nmap' '<leader>'.g:br_subleader_qf.g:br_subleader_qf '<plug>(qf_qf_toggle)'
execute 'nmap' '<leader>'.g:br_subleader_qf.'w' '<plug>(qf_qf_switch)'

execute 'nmap' '<leader>'.g:br_subleader_qf.'p' '<plug>(qf_qf_previous)'
execute 'nmap' '<leader>'.g:br_subleader_qf.'n' '<plug>(qf_qf_next)'

" DEPRECATED {{{1
" Compiler workflow.
" Make and display quickfix window.
nnoremap <leader>8 :silent make! %<cr><c-l>:cwindow<cr>
" <leader>9 reserved for 'run' or 'compile+run'; see ftplugin files.

" vimspector
" See [https://github.com/puremourning/vimspector#mappings].
nmap <leader>2      <Plug>VimspectorContinue
nmap <leader><c-2>  <Plug>VimspectorStop
nmap <leader>3      <Plug>VimspectorPause
nmap <leader>4      <Plug>VimspectorToggleBreakpoint
nmap <leader><c-4>  <Plug>VimspectorAddFunctionBreakpoint
nmap <leader>5      <Plug>VimspectorStepOver
nmap <leader>6      <Plug>VimspectorStepInto
nmap <leader><c-6>  <Plug>VimspectorStepOut
nmap <leader>0      <Plug>VimspectorRunToCursor

" Window resizing.
execute "nnoremap" "<c-w><c-h>" ":vertical resize -".g:br_resize_width."<cr>"
execute "nnoremap" "<c-w><c-l>" ":vertical resize +".g:br_resize_width."<cr>"
execute "nnoremap" "<c-w><c-j>" ":resize -".g:br_resize_height."<cr>"
execute "nnoremap" "<c-w><c-k>" ":resize +".g:br_resize_height."<cr>"

" Toggle list.
nmap <leader>l :set list!<cr>

inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" toggle cursor column
if has('syntax')
    nnoremap <leader>c :set cursorcolumn!<cr>
endif

if exists("g:sandwich#default_recipes")
    " add
    nmap ys <Plug>(sandwich-add)
    xmap ys <Plug>(sandwich-add)
    omap ys <Plug>(sandwich-add)
    " delete
    nmap ds <Plug>(sandwich-delete)
    xmap ds <Plug>(sandwich-delete)
    nmap dsb <Plug>(sandwich-delete-auto)
    " replace
    nmap cs <Plug>(sandwich-replace)
    xmap cs <Plug>(sandwich-replace)
    nmap csb <Plug>(sandwich-replace-auto)
    " text-objects
    omap ib <Plug>(textobj-sandwich-auto-i)
    xmap ib <Plug>(textobj-sandwich-auto-i)
    omap ab <Plug>(textobj-sandwich-auto-a)
    xmap ab <Plug>(textobj-sandwich-auto-a)
    " conflicts with builtin sentence textobj
    " omap is <Plug>(textobj-sandwich-query-i)
    " xmap is <Plug>(textobj-sandwich-query-i)
    " omap as <Plug>(textobj-sandwich-query-a)
    " xmap as <Plug>(textobj-sandwich-query-a)
endif
