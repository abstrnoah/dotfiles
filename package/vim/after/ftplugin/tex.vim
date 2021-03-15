" Compiler.
compiler an_makedoc_tex
" Compile and preview.
nnoremap <buffer> <leader>9
    \ :silent !<c-r>=&makeprg<cr> --preview -r 1 %<cr><c-l>


" Disable indent because default latex indenting is stupid.
filetype indent off

" Format lists.
" We `-=` and `+=` each formatlistpat to avoid duplication because for some
" reason this file is sourced around three times. It must have something to do
" with vim-latex, because this does not occur with other ftplugin files. (TODO
" figure out what's going on.)
setlocal formatoptions+=n
" Easylist.
setlocal formatlistpat-=\\\|^\\s*&\\+\\s*
setlocal formatlistpat+=\\\|^\\s*&\\+\\s*



"
" Configure vim-latex.
"

" Disable folding.
" (`nofoldenable` in vimrc is insufficient because vim-latex sets folding late.)
setlocal nofoldenable

let g:Tex_EnvEndWithCR = 1

" TODO: These are trash and incomplete.
let g:Tex_Env_{'thm'} = "\\begin{thm}<++>\<CR><++>\<CR>\\end{thm}"
let g:Tex_Env_{'prop'} = "\\begin{prop}<++>\<CR><++>\<CR>\\end{prop}"
let g:Tex_Env_{'lemma'} = "\\begin{lemma}<++>\<CR><++>\<CR>\\end{lemma}"
let g:Tex_Env_{'easylist'} =
    \ "\\begin{easylist}<++>\<CR><++>\<CR>\\end{easylist}"
let g:Tex_Env_{'align'} =
    \ "\\begin{align}<++>\<CR><++>\<CR>\\end{align}"
let g:Tex_Env_{'soln'} = "\\begin{soln}\<CR><++>\<CR>\\end{soln}"
