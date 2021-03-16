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

" Navigation: tags, ctrlp.
nmap <leader>n :call AN_NERDTree()<cr>
nmap <leader>m :TagbarOpenAutoClose<CR>
nnoremap <c-p> :CtrlPMixed<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>. :CtrlPTag<cr>

" Spell.
nmap <leader>s :set spell!<cr>

" Search.
nnoremap <leader>/ :S<space>
nnoremap <leader>? :SB<space>


" Compiler workflow.
" Make and display quickfix window.
nnoremap <leader>8 :silent make! %<cr><c-l>:cwindow<cr>
" <leader>9 reserved for 'run' or 'compile+run'; see ftplugin files.


" Toggle colorcolumn with table mode.
nnoremap <leader>tm :call ToggleColorColumn()<cr>:TableModeToggle<cr>
