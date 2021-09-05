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
            \ "line": "'[V']y",
            \ "char": "`[v`]y",
            \ "block": "`[\<c-v>`]y",
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

" MANAGEMENT {{{2

" declare_plugs(specs, active_plugs) {{{3
" Given a dictionary 'specs' like 'g:br_plugs' (see the comment for that global
" for its schema), run vimplug 'Plug ...' commands for the plugins specified in
" list 'active_plugs'.
function funs#declare_plugs(specs, active_plugs) abort
    for plug_name in a:active_plugs
        if has_key(a:specs, plug_name)
            if !funs#declare_plug(plug_name, a:specs)
                echomsg "No compatible version of plugin '".plug_name."' found."
            endif
        endif
    endfor
endfunction

" declare_plug(name, spec) {{{3
" Given a plugin name (as recognised by vimplug) and a list of version specs
" 'ver_specs' (see 'g:br_plugs'), run the approporiate vimplug 'Plug ...'
" command. If a compatible version is found and declared, return 1. Otherwise
" return 0.
function funs#declare_plug(name, specs) abort
    let l:spec = funs#get_plug_spec(a:name, a:specs)
    if  l:spec is 0
        return 0
    endif
    let l:args = [string(a:name)]
    " If no or empty spec given, pass through empty string.
    if !empty(l:spec)
        let args = add(l:args, string(l:spec))
    endif
    " Run the actual Plug command.
    exe "Plug" join(l:args, ", ")
    return 1
endfunction

" get_plug_spec(name, specs) {{{3
" Return the "best" plug spec dictionary for vim-plug for plugin 'name' given
" 'specs' which has schema like 'g:br_plugs'. By "best" we mean that we traverse
" the version spec list in the 'name' item of 'specs' dict until we find a
" supported() plug. If the best plug spec dict is missing keys or non-existent
" then return empty dict. If no supported plugin is found, then return 0.
function funs#get_plug_spec(name, specs) abort
    if empty(a:name)
        echoerr "Plugin name is empty."
        return 0
    endif
    if !has_key(a:specs, a:name)
        echoerr "Plugin name not in specs."
        return 0
    endif
    let l:ver_specs = a:specs[a:name]
    " If version list is empty, assume is supported and default version.
    if empty(l:ver_specs)
        let l:ver_specs = [{"spec": {}, "supported": {-> 1}}]
    endif
    " Loop until a supported version is found.
    for l:ver_spec in l:ver_specs
        " Check if supported; lack of supported() function implies is supported.
        if get(l:ver_spec, "supported", {-> 1})()
            return get(l:ver_spec, "spec", {})
        endif
    endfor
    return 0
endfunction


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
