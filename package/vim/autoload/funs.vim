" Author: Noah <abstractednoah@brumal.org>


function funs#nerdtree() abort
    " Call `:NERDTreeFind` if path nonempty, otherwise `:NERDTreeVCS`.
    if &modifiable && strlen(expand("%")) > 0 && !&diff
        NERDTreeFind
    else
        NERDTreeVCS
    endif
endfunction

" Search across lines and non-word characters. Case-sensitive if '!'. [^1]
function funs#multiSearch(bang, ...) abort
    if a:0 > 0
        "let sep = (a:bang) ? '\_W\+' : '\_s\+'
        let sep = '\(\_W\|_\)\+'
        let @/ = join(a:000, sep) . ((a:bang) ? "" : '\c')
    endif
endfunction

function funs#toggleColorColumn() abort
    if &colorcolumn == ""
        setlocal colorcolumn=g:br_colorcolumn
    else
        setlocal colorcolumn=
    endif
endfunction

function funs#toggleTableMode() abort
    if tablemode#IsActive()
        let &l:colorcolumn = g:br_colorcolumn
        call tablemode#Disable()
    else
        setlocal colorcolumn=
        call tablemode#Enable()
    endif
endfunction

if has("folding")
    function funs#foldtext() abort
        let l:line = getline(v:foldstart)
        " Pattern of what to remove from line to produce fold summary text.
        let l:rm_pattern = '\s{{{\d\=$\|^\s*\("\|#\|//\)\s' "}}}
        let l:text = substitute(l:line, l:rm_pattern, "", "g")
        let l:line_count = v:foldend - v:foldstart
        return printf(
            \ '%-4s %-55.55s  > %3d lines <%s',
            \ v:folddashes, l:text, l:line_count, repeat(" ", 5)
        \ )
    endfunction
endif

" NOTES {{{1
" [^1]: https://vim.fandom.com/wiki/Search_across_multiple_lines

" vim:ft=vim:fdm=marker:fmr={{{,}}}:fen:tw=80:et:ts=4:sts=4:sw=0:
