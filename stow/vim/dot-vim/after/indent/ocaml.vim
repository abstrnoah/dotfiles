set tabstop=2
let &comments = 's1:(*,mb:*,ex:*)'

" Overwritted by shipped runtimes for some reason.
if v:version > 703 || v:version == 703 && has("patch541")
    " Delete comment character when joining lines.
    set formatoptions+=j
endif
