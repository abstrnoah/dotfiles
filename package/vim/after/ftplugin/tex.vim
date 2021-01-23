"
" Compiler workflow.
"
compiler an_makedoc_tex
" Compile and preview.
nnoremap <buffer> <leader>9
    \ :silent !<c-r>=&makeprg<cr> --preview %<cr><c-l>


"
" Configure vim-latex.
"
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
