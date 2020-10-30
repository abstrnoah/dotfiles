" unhighlight on <ESC>
nnoremap <silent> <ESC> :noh<CR><ESC>

" disable various dumb keys
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

" newline
nnoremap <C-o> o<ESC>
