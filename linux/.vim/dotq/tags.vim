
"  Tags {{{1
set tags=tags,../tags
let g:ctags_cpp_opts = "--c++-kinds=+p --fields=+iaS --extra=+q --languages=c++"
func! MkTags()
    exe 'silent !ctags '. g:ctags_cpp_opts .' -R *'
endfun


" Ctrl-] doesn't work on my dvorak keyboard, so use ,t
"map ,t <C-]>
map ,t :execute 'Unite tag:' . expand("<cword>") . ' -immediately'<CR>

map ,<space> :tn<CR>
map ,<bs> :tp<CR>
