" Functional wrapper around operators, g@ and 'opfunc'.
" Author: abstractednoah at brumal dot org

" CONSTANTS {{{1

" Visual modes equivalent to the motion types (see ':help g@').
let s:motion_type_to_visual = {
    \ "line": "'[V']",
    \ "char": "`[v`]",
    \ "block": "`[\<c-v>`]",
    \ "visual": "gv"
\ }


" PRIVATE HELPERS {{{1

" s:sandbox(func) {{{
" Sandbox decorator (a Partial) to use for operator functions.
let s:sandbox = function("brumal#main#sandbox", [['"', 'a'], ["'<", "'>"]])
" }}}

" s:getMotionText(type) {{{
" Return the text of the last motion (the object of a operator, see g@).
" Notice: Should be executed in a sandbox, alters quote-register.
function s:getMotionText(type) abort
    let l:keystroke = get(s:motion_type_to_visual, a:type, '') . "y"
    silent execute 'noautocmd keepjumps normal!' l:keystroke
    return getreg('"')
endfunction " }}}

" s:setMotionText(text, type) {{{
" Set motion text to 'text'. Counterpart to s:getMotionText.
" Return the original motion text.
" Notice: Should be executed in a sandbox, alters registers a and quote.
function s:setMotionText(text, type) abort
    let l:old_paste = &paste
    try
        set paste
        call setreg('a', a:text)
        " Replace visually selected text with contents of quote-register.
        silent execute 'noautocmd keepjumps normal!'
            \ get(s:motion_type_to_visual, a:type, '') . "c\<c-r>a"
        return getreg('"')
    finally
        let &paste = l:old_paste
    endtry
endfunction " }}}

" PUBLIC LIBRARY {{{1

" brumal#opfunc#opfunc(func) {{{
"   Decorator that turns 'func' into a function suitable for 'operatorfunc'.
"   That is, the function returned by this wrapper takes one String argument,
"   the type of the motion (see :help 'operatorfunc' and g@).
"   'func' should be a function that takes exactly one String argument, the
"   text of the motion given to the operator.
"   Does not need sandbox, leaves things as it finds them.
function brumal#opfunc#opfunc(func) abort
    return s:sandbox({type -> a:func(s:getMotionText(type))})
endfunction " }}}

" altererOpfunc(func) {{{
" Like opfunc but the motion text is replaced with the result of 'func' and the
" original motion text is returned. Registers are untouched; it is up to you to
" set the result to the unnammed register if you desire.
function brumal#opfunc#altererOpfunc(func) abort
    return s:sandbox({
        \ type ->  s:setMotionText(a:func(s:getMotionText(type)), type)
    \ })
endfunction " }}}

" vim: set ft=vim fdm=marker fmr={{{,}}} fen tw=80 et ts=4 sts=4 sw=0: {{{1
