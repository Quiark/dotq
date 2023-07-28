
"  Tags {{{1
set tags=tags,../tags
let g:ctags_cpp_opts = "--c++-kinds=+p --fields=+iaS --extra=+q --languages=c++ "
func! MkTags()
	" cant have -R here by default, what if I dont want all subdirs (atopenssl
	" has many build variants)
    exe 'silent !ctags '. g:ctags_cpp_opts .' ./*'
endfun


" Ctrl-] doesn't work on my dvorak keyboard, so use ,t
"map ,t <C-]>
map ,t :execute 'Denite tag:' . expand("<cword>") . ' -immediately'<CR>

map ,<space> :tn<CR>
map ,<bs> :tp<CR>
