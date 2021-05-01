"
" Compiler workflow.
"
compiler an_makedoc_mdk
" Compile and preview.
nnoremap <buffer> <leader>9
    \ :silent !<c-r>=&makeprg<cr> --preview %<cr><c-l>:cwindow<cr>


" Override tagbar by vim-markdown's `:Toc`.
nmap <leader>fm :Toc<CR>


" This is nearly the default, except it adds `\s*` before symbolic bullets. For
" some reason the default only matches leading space for numerical bullets. This
" fixes hanging indent for bullets at all levels.
" Also adds support for checklist-style bullets.
setlocal formatlistpat-=\\\|^[-*+]\\s\\+
setlocal formatlistpat+=\\\|^\\s*\\d\\+\\.\\s\\+
setlocal formatlistpat+=\\\|^\\s*[-*+]\\(\\s\\[.\\]\\)\\?\\s\\+
setlocal formatlistpat+=\\\|^\\s*\\[^\\ze[^\\]]\\+\\]:
