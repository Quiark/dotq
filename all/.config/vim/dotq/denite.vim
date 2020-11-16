" TODO
"  - select target window (also for Defx)
"  - start buffer with insert mode
"  - start Defx always on the left

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action', 'open_with_choosewin')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

" Change file/rec command.
call denite#custom#var('file/rec', 'command',
\ ['ack'])

" Change matchers.
call denite#custom#source(
\ 'file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
call denite#custom#source(
\ 'file/rec', 'matchers', ['matcher/cpsm'])

" Change sorters.
call denite#custom#source(
\ 'file/rec', 'sorters', ['sorter/sublime'])

" Change default action.
call denite#custom#kind('file', 'default_action', 'split')


" Ack command on grep source
call denite#custom#var('grep', {
	\ 'command': ['ack'],
	\ 'default_opts': [
	\   '--ackrc', $HOME.'/.ackrc', '-H', '-i',
	\   '--nopager', '--nocolor', '--nogroup', '--column'
	\ ],
	\ 'recursive_opts': [],
	\ 'pattern_opt': ['--match'],
	\ 'separator': ['--'],
	\ 'final_opts': [],
	\ })


" Define alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
	  \ ['git', 'ls-files', '-co', '--exclude-standard'])


" Change ignore_globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
	  \ [ '.git/', '.ropeproject/', '__pycache__/',
	  \   'venv/',  '*.min.*'])


function! s:is_ignore_window(winnr)
  let ignore_filtype = ["unite", "vimfiler", "vimshell", "nerdtree", "denite", "defx"]
  return index(ignore_filtype, getbufvar(winbufnr(a:winnr), "&filetype")) != -1
endfunction

" TODO ok now make it work with defx
" well defx has different format of context argument
function! OpenWithChoosewin(context)
	let path = a:context['targets'][0]['action__path']
	call s:openWithChoose(path)
endfun

function! s:openWithChoose(path)
	let wins = range(1,winnr('$'))
	let choice = choosewin#start(
		  \ filter(wins, '!s:is_ignore_window(v:val)'),
		  \ { 'auto_choose': 1, 'hook_enable': 0 }
		  \ )

	if !empty(choice)
	  let [tab, win] = choice
	  execute 'tabnext' tab
		"switch to window nr ...
	  execute win 'wincmd w'  
	  execute 'e ' . a:path
	endif
endfunction

function! DefxOpenWithChoosewin(context)
	let path = a:context.targets[0]
	call s:openWithChoose(path)
endfun

call denite#custom#action('buffer,directory,file,openable', 'open_with_choosewin', function('OpenWithChoosewin'))

" =========================== DeFX =================================
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('call', 'DefxOpenWithChoosewin')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('preview')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('open_tree', 'toggle') . 'j'
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
  nnoremap <silent><buffer><expr> <BS>
  \ defx#do_action('cd', '..')
endfunction

" =========================== custom =================================
map ,b :Denite buffer<CR>
map ,e :Defx -split=vertical -winwidth=40 -direction=topleft<CR>
