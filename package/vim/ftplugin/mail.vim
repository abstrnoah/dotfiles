" Forked by abstractednoah@brumal.org from:
"
" Vim filetype plugin file
" Language:	Mail
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2012 Nov 20

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl modeline< tw< fo< comments<"

" Don't use modelines in e-mail messages, avoid trojan horses and nasty
" "jokes" (e.g., setting 'textwidth' to 5).
setlocal nomodeline

" many people recommend keeping e-mail messages 72 chars wide
" if &tw == 0
"   setlocal tw=72
" endif

" What are we in 2002? The majority of people have clients that will display
" 74-col hardwrapped messages as garbage. As much as I would love to hardwrap,
" it's not practical.
setlocal textwidth=0
setlocal colorcolumn=

" Set 'formatoptions' to break text lines and keep the comment leader ">".
setlocal fo+=tcql

" Add n:> to 'comments, in case it was removed elsewhere
setlocal comments+=n:>

" Add mappings, unless the user doesn't want this.
if !exists("no_plugin_maps") && !exists("no_mail_maps")
  " Quote text by inserting "> "
  if !hasmapto('<Plug>MailQuote')
    vmap <buffer> <LocalLeader>q <Plug>MailQuote
    nmap <buffer> <LocalLeader>q <Plug>MailQuote
  endif
  vnoremap <buffer> <Plug>MailQuote :s/^/> /<CR>:noh<CR>``
  nnoremap <buffer> <Plug>MailQuote :.,$s/^/> /<CR>:noh<CR>``
endif
