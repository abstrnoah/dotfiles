" Forked by abstractednoah@brumal.org from:
"
" Vim filetype plugin file
" Language:	Mail
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2012 Nov 20

" Only do this when not done yet for this buffer.
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" TODO: Finish undo_ftplugin.
let b:undo_ftplugin = "setl modeline< textwidth< formatoptions< comments<"

" Don't use modelines in e-mail messages, avoid trojan horses and nasty
" "jokes" (e.g., setting 'textwidth' to 5).
setlocal nomodeline

" Many people recommend keeping e-mail messages 72 chars wide.
setlocal textwidth=72
call EnableColorColumn()

" Set 'formatoptions' to break text lines and keep the comment leader ">".
setlocal formatoptions+=tcql

" Comments (aka block quotation in mails).
setlocal comments+=n:>
setlocal commentstring=>\ %s

" Avoid incoming (unmodifiable) mails lighting up light a red christmas tree bc
" someone else doesn't know how to remove trailing whitespace.
if !&modifiable
    match none /\s\+$/
endif
