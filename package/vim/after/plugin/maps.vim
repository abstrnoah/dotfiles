" Clear previous leader mappings.
nnoremap <leader> <nop>
inoremap <leader> <nop>

" Unhighlight on <ESC>.
nnoremap <silent> <ESC> :noh<CR><ESC>

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
" for some reason this isn't f*****g working
inoremap <silent> <BS> <NOP>

" Disable ex-mode keys.
map Q <nop>
" Doesn't seem to work TODO.
"map gQ <nop>

" Exploration.
exe "nnoremap" g:br_leader_nav.."m" ":TagbarOpenAutoClose<CR>"
exe "nnoremap" g:br_leader_nav.."n" ":call funs#nerdtree()<cr>"
exe "nnoremap" g:br_leader_nav.."p" ":CtrlPMixed<cr>"
exe "nnoremap" g:br_leader_nav.."b" ":CtrlPBuffer<cr>"
exe "nnoremap" g:br_leader_nav.."l" ":CtrlPLine<cr>"
exe "nnoremap" g:br_leader_nav.."t" ":CtrlPTag<cr>"

" Spell.
nmap <leader>s :set spell!<cr>

" Search.
nnoremap <leader>/ :S<space>
nnoremap <leader>? :SB<space>

" clipboard
map <leader>y "+y
map <leader>p "+p
map <leader>P "+P
" Yank text into clipboard "+ register, and join paragraphs into single lines,
" in place in the register. That is, the original text is unchanged, but the
" register text will be removed of its hardwraps. Paragraphs
" (double-newline-separated) are preserved as separate double-newline-separated
" lines.
vnoremap <leader>Y
    \ "+y:let @+ = substitute(@+, '[^\n]\zs\n\ze[^\n]', " ", "g")<cr>

" Compiler workflow.
" Make and display quickfix window.
nnoremap <leader>8 :silent make! %<cr><c-l>:cwindow<cr>
" <leader>9 reserved for 'run' or 'compile+run'; see ftplugin files.


" Toggle colorcolumn with table mode.
nnoremap <leader>tm :call funs#toggleTableMode()<cr>

" vim-sneak
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

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
