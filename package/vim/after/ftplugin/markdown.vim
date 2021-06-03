"
" Compiler workflow.
"
compiler an_makedoc_mdk
" Compile and preview.
nnoremap <buffer> <leader>9
    \ :silent !<c-r>=&makeprg<cr> --preview %<cr><c-l>:cwindow<cr>

" This is nearly the default, except it adds `\s*` before symbolic bullets. For
" some reason the default only matches leading space for numerical bullets. This
" fixes hanging indent for bullets at all levels.
" Also adds support for checklist-style bullets.
setlocal formatlistpat-=\\\|^[-*+]\\s\\+
setlocal formatlistpat+=\\\|^\\s*\\d\\+\\.\\s\\+
setlocal formatlistpat+=\\\|^\\s*[-*+]\\(\\s\\[.\\]\\)\\?\\s\\+
setlocal formatlistpat+=\\\|^\\s*\\[^\\ze[^\\]]\\+\\]:

" MAPPINGS
exe "nnoremap <buffer> <localleader>" .. g:br_leader_explore .. "m :Toc<cr>"
