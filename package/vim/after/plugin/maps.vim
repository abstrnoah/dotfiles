" Author: Noah <abstractednoah@brumal.org>

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
" This doesn't actually disable backspace, idk why.
inoremap <silent> <BS> <NOP>

" Disable ex-mode keys.
map Q <nop>
" Doesn't seem to work TODO.
"map gQ <nop>

" EXPLORE {{{1
execute "nnoremap" g:br_leader_nav."m" ":TagbarOpenAutoClose<CR>"
execute "nnoremap" g:br_leader_nav."n" ":call funs#nerdtree()<cr>"
execute "nnoremap" g:br_leader_nav."p" ":CtrlPMixed<cr>"
execute "nnoremap" g:br_leader_nav."b" ":CtrlPBuffer<cr>"
execute "nnoremap" g:br_leader_nav."l" ":CtrlPLine<cr>"
execute "nnoremap" g:br_leader_nav."t" ":CtrlPTag<cr>"

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
    nnoremap <leader>Y :set operatorfunc=funs#yankUnformattedOperator<cr>g@
    nnoremap <leader>YY :set operatorfunc=funs#yankUnformattedOperator<cr>g@_
    xnoremap <leader>Y :<c-u>call funs#yankUnformattedOperator("visual")<cr>
endif

" TABLE-MODE {{{1

nnoremap <leader>tm :call funs#toggleTableMode()<cr>


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
