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

" Navigation: tags, ctrlp.
nmap <leader>n :call AN_NERDTree()<cr>
nmap <leader>m :TagbarOpenAutoClose<CR>
nnoremap <c-p> :CtrlPMixed<cr>
" Maybe remove this, if <c-p> as CtrlPMixed suffices.
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>. :CtrlPTag<cr>

" Spell.
nmap <leader>s :set spell!<cr>


"
" Compiler workflow.
"
" Make and displace quickfix window.
nnoremap <leader>8 :silent make %<cr><c-l>:cwindow<cr>
" <leader>9 reserved for 'run' or 'compile+run'; see ftplugin files.
