" Compiler.
compiler an_makedoc_tex
" Compile and preview.
nnoremap <buffer> <leader>9
    \ :silent !<c-r>=&makeprg<cr> --preview -r 1 %<cr><c-l>


" Format lists.
" We `-=` and `+=` each formatlistpat to avoid duplication because for some
" reason this file is sourced around three times. It must have something to do
" with vim-latex, because this does not occur with other ftplugin files. (TODO
" figure out what's going on.)
setlocal formatoptions+=n
" Easylist.
setlocal formatlistpat-=\\\|^\\s*&\\+\\s*
setlocal formatlistpat+=\\\|^\\s*&\\+\\s*
