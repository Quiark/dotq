" Unite and vimFiler settings
" Unite {{{1

let g:unite_source_grep_command = 'ack'
let g:unite_source_grep_default_opts = '--no-heading --no-color -H'
let g:unite_source_grep_recursive_opt = ''
"let g:unite_source_rec_async_command = 'notepad'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
" Requires vimproc
"map ,a :Unite -start-insert grep:.<CR>
map ,p :Unite file -start-insert<CR>
map ,b :Unite buffer -start-insert<CR>
map ,n :Unite tag -start-insert<CR>


" VimFilerEx {{{1
map ,e :VimFilerEx<CR>
let g:vimfiler_as_default_explorer = 1
autocmd FileType vimfiler nmap <buffer> <2-LeftMouse> <Plug>(vimfiler_edit_file)
