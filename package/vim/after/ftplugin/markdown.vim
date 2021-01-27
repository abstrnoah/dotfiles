"
" Compiler workflow.
"
compiler an_makedoc_mdk
" Compile and preview.
nnoremap <buffer> <leader>9
    \ :silent !<c-r>=&makeprg<cr> --preview %<cr><c-l>:cwindow<cr>


"
" Plugins
"

" Tagbar
let g:tagbar_sort = 0
