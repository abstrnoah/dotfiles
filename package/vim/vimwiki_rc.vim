" Vimwiki runtime config.
" Author: abstractednoah at brumal dot org

" WIKI LOCAL OPTIONS {{{1

let g:vimwiki_list = [
    \ {
        \ "path": "~/repository/notes/vimwiki/",
        \ "name": "notes",
        \ "auto_toc": 1,
        \ "index": "root",
        \ "links_space_char": "_",
        \ "diary_rel_path": "dates/",
        \ "diary_index": "root",
        \ "diary_header": "DATES",
        \ "auto_tags": 1,
        \ "auto_diary_index": 1,
        \ "auto_generate_links": 1,
        \ "auto_generate_tags": 1
    \ }
\ ]



" GLOBAL OPTIONS {{{1

let g:vimwiki_map_prefix = g:br_leader_note
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_folding = "expr"
let g:vimwiki_toc_header = "CONTENTS"
let g:vimwiki_toc_header_level = 2
let g:vimwiki_links_header = "INDEX OF INLINKS"
let g:vimwiki_links_header_level = 2
let g:vimwiki_tags_header = "INDEX OF TAGS"
let g:vimwiki_tags_header_level = 2
let g:vimwiki_auto_header = 1
let g:vimwiki_dir_link = "root"


" COMMANDS {{{1

command VimwikiBrReadTemporal read !date '+:temporal-\%Y-\%m-\%d-\%H-\%M-\%Z:'

command VWT VimwikiBrReadTemporal
