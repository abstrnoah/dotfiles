" Author: Noah <abstractednoah@brumal.org>

" Note: Functions that need if-guards (such as plugin wrappers) go elsewhere,
" usually in PLUGIN CONFIG section of vimrc.

" GENERAL {{{1
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

if has("folding")
    function funs#foldtext() abort
        let l:line = getline(v:foldstart)
        " Pattern of what to remove from line to produce fold summary text.
        let l:rm_pattern = '\s{{{\d\=$\|^\s*\("\|#\+\|//\|%\+\)\s' "}}}
        let l:text = substitute(l:line, l:rm_pattern, "", "g")
        let l:line_count = v:foldend - v:foldstart
        return printf(
            \ '%-4s %-55.55s  > %3d lines <',
            \ v:folddashes, l:text, l:line_count
        \ )
    endfunction
endif

function funs#unformat(text) abort
    return substitute(a:text, '[^\n]\zs\n\ze[^\n]', " ", "g")
endfunction

function funs#removeLeadingWhitespace(text) abort
    return substitute(a:text, '\(\_^\|\n\)\zs\s\+', "", "g")
endfunction

" OPERATORS {{{1
" funs#opfunc(func, type) {{{2
"   Wrap a function so as to be used as an operatorfunc in the form of a
"   Partial. The intended pattern is something like
"
"       :let g:MyOpFunc = funcref(funs#opfunc, [MyFunc])
"       :nnoremap <leader>x :set operatorfunc=g:MyOpFunc<cr>g@
"
"   It also supports visual selection "operators"; just pass the "visual" type:
"
"       :xnoremap <leader>x :<c-u>call g:MyOpFunc("visual")<cr>
"
"   We need to store the Funcref in a variable rather than pass it directly to
"   operatorfunc because operatorfunc only accepts a string name to the
"   function.
"   The 'func' should be a function that takes exactly one string argument, the
"   text of the motion passed to the operator.
"   Return the result of 'func(motionText)'.
function funs#opfunc(func, type) abort
    let l:old_selection = &selection
    let l:old_register = getreginfo('"')
    let l:old_clipboard = &clipboard
    let l:old_visual_marks = [getpos("'<"), getpos("'>")]
    try
        set clipboard= selection=inclusive
        let l:commands = #{
            \ line: "'[V']y", char:"`[v`]y", block: "`[\<c-v>`]y",
            \ visual: "gvy"
        \ }
        silent execute 'noautocmd keepjumps normal!' get(l:commands, a:type, '')
        return a:func(getreg('"'))
    finally
        call setreg('"', l:old_register)
        call setpos("'<", l:old_visual_marks[0])
        call setpos("'>", l:old_visual_marks[1])
        let &clipboard = l:old_clipboard
        let &selection = l:old_selection
    endtry
endfunction

" funs#yankUnformattedOperator(type) {{{2
"   An operatorfunc that sets the '+' register to the "unformatted" version of
"   the motion's text. By "unformatted", we mean roughly the inverse operation
"   to the format operator 'gq'. It is difficult to exactly invert 'gq', so this
"   is only an approximate inverse, but it is useful when, for instance,
"   drafting a note in vim with nice vim formatting such as with hard wrapping
"   but then want to paste the draft into a form that is not suited for
"   80-character hard-wrapped text.
function funs#yankUnformattedOperator(type) abort
    let @+ = funs#opfunc(
        \ {text -> funs#unformat(funs#removeLeadingWhitespace(text))},
        \ a:type
    \ )
    echom "Unformattedly yanked into \"+."
endfunction

" PLUGIN {{{1
" Functions that wrap plugin functionality.

" NERDTREE {{{2
function funs#nerdtree() abort
    " Call `:NERDTreeFind` if path nonempty, otherwise `:NERDTreeVCS`.
    if &modifiable && strlen(expand("%")) > 0 && !&diff
        NERDTreeFind
    else
        NERDTreeVCS
    endif
endfunction

" TABLE MODE {{{2
function funs#toggleTableMode() abort
    if tablemode#IsActive()
        let &l:colorcolumn = g:br_colorcolumn
        call tablemode#Disable()
    else
        setlocal colorcolumn=
        call tablemode#Enable()
    endif
endfunction

" NOTES {{{1
" [^1]: https://vim.fandom.com/wiki/Search_across_multiple_lines

" vim:ft=vim:fdm=marker:fmr={{{,}}}:fen:tw=80:et:ts=4:sts=4:sw=0:
