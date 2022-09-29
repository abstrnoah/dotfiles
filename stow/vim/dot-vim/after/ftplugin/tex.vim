" Enable spell check by default in tex documents.
set spell

" Use vimtex's doc.
map <buffer> K <Plug>(vimtex-doc-package)
" Use vimtex's ToC
exe "nmap <buffer>" g:br_leader_nav.."m" "<plug>(vimtex-toc-open)"

" Custom surrounds
" TeXt -> %%<newline>TeXt%%<newline>
let b:surround_{char2nr('P')} = "%%\n\r%%\n"
