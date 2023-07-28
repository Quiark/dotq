" gonna break my fingers on this ...
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gq <Plug>(coc-float-hide)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> go :<C-u>CocList -I symbols<cr>
nnoremap <silent> gh :call CocActionAsync('doHover')<cr>
nmap <silent> gA :call CocAction('doQuickfix')<cr>
nmap <silent> ga <Plug>(coc-codeaction)

" show completion
inoremap <silent><expr> <c-space> coc#refresh()


" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
"nmap <silent> gc :CocAction<cr>

" TODO need to set color of float windows
hi NormalFloat guibg=#987890

autocmd CursorHold * silent call CocActionAsync('highlight')

set updatetime=500

" these need to be done in already opened window
set number
set signcolumn=number

