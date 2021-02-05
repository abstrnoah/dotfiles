"
" Compiler workflow.
"
compiler an_makedoc_mdk
" Compile and preview.
nnoremap <buffer> <leader>9
    \ :silent !<c-r>=&makeprg<cr> --preview %<cr><c-l>:cwindow<cr>


" Override tagbar by vim-markdown's `:Toc`.
nmap <leader>m :Toc<CR>
