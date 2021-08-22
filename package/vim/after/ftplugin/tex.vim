" OPTIONS {{{1
" Format lists.
" We `-=` and `+=` each formatlistpat to avoid duplication because for some
" reason this file is sourced around three times. It must have something to do
" with vim-latex, because this does not occur with other ftplugin files. (TODO
" figure out what's going on.)
setlocal formatoptions+=n
" Easylist.
setlocal formatlistpat-=\\\|^\\s*&\\+\\s*
setlocal formatlistpat+=\\\|^\\s*&\\+\\s*

" Enable spell check by default in tex documents.
set spell

" MAPS {{{1
" Use vimtex's doc.
map <buffer> K <Plug>(vimtex-doc-package)
" Use vimtex's ToC
exe "nmap <buffer>" g:br_leader_nav.."m" "<plug>(vimtex-toc-open)"


" CUSTOM SURROUNDS {{{1
" TeXt -> %%<newline>TeXt%%<newline>
let b:surround_{char2nr('P')} = "%%\n\r%%\n"
