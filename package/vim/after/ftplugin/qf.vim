"
" Quickfix window rc.
" Applies to both quickfix and locationslist windows.
"

" Disable wrap for more readable TOC.
set nowrap

" Easy close with `q`.
" (Hint: use `<C-w>_` to maximize horizontally).
nnoremap <buffer><silent> q :q<cr>

" Close quickfix or locationlist on jump.
nnoremap <buffer><silent> <cr> <cr>:cclose<cr>:lclose<cr>
