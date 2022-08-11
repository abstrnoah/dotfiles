" Enable spell check by default.
set spell

" Mappings
exe "nnoremap <buffer>" g:br_leader_nav.."m" ":Toc<cr>"
" Override a terrible choice by markdown plugin.
silent! nunmap <buffer> ge
