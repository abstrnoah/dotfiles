" Author: Noah <abstractednoah@brumal.org>

" GENERAL {{{1
" funs#multiSearch(case_sensitive, word_boundaries, tokens...) {{{2
"   Produce a pattern for searching for tokens across lines and non-word
"   characters, with the option of case sensitivity and of adding '\<','\>' word
"   boundaries around the tokens. When not word_boundaries, also search across
"   underscores. Inspired by [^1]. Note that this isn't super robust, as the
"   behavior of the returned pattern might depend on your settings. We assume
"   'noignorecase', 'nosmartcase', and 'magic'.
function funs#multiSearch(case_sensitive, word_boundaries, ...) abort
    if a:0 > 0
        " Search for tokens delimited by the following separators:
        " \_W non-word including end-of-line.
        " _ underscores.
        let l:sep = '\(\_W\|_\)\+'
        " Note that word_boundaries overrides the '_' separator.
        if a:word_boundaries
            let l:words = map(deepcopy(a:000), '"\\<" . v:val . "\\>"')
        else
            let l:words = a:000
        endif
        return join(l:words, l:sep) . ((a:case_sensitive) ? "" : '\c')
    else
        return ''
    endif
endfunction

" {{{2
function funs#toggleColorColumn() abort
    if &colorcolumn == ""
        setlocal colorcolumn=g:br_colorcolumn
    else
        setlocal colorcolumn=
    endif
endfunction

" {{{2
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

" {{{2
function funs#unformat(text) abort
    return substitute(a:text, '[^\n]\zs\n\ze[^\n]', " ", "g")
endfunction

" {{{2
function funs#removeLeadingWhitespace(text) abort
    return substitute(a:text, '\(\_^\|\n\)\zs\s\+', "", "g")
endfunction

" {{{2
function funs#removeFinalNewline(text) abort
    return substitute(a:text, '\n\_$', "", "g")
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
        let l:commands = {
            \ "line": "'[V']y", char:"`[v`]y", block: "`[\<c-v>`]y",
            \ "visual": "gvy"
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
        \ {text
            \ -> funs#removeFinalNewline(
                \ funs#unformat(
                    \ funs#removeLeadingWhitespace(
                        \ text
                    \)
                \ )
            \ )
        \ },
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
