" TODO
"  + select target window (also for Defx)
"  + start buffer with insert mode
"  + start Defx always on the left
"  + choosewin offers quickfix window as candidate
"  + enable cursorline for Defx
"  + icons for Defx
"  - press Enter once in Denite to open the item
"  - could have different shortcut, say, [,h] which will open buffer selection
"    without choosing the target window and opens here
"  - enter folder on CR (set it as top-level)

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  if b:denite.buffer_name == 'menu'
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action')
  else
    nnoremap <silent><buffer><expr> <CR>
    \ denite#do_map('do_action', 'open_with_choosewin')
  endif
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
  " for the menu thing because open with 
  nnoremap <silent><buffer><expr> o
  \ denite#do_map('do_action')
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <Esc> <Plug>(denite_filter_quit)
endfunction

" Change file/rec command to ripgrep
call denite#custom#var('file/rec', 'command',  ['rg', '--files', '--glob', '!.git', '--color', 'never'])


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
	\ 'command': ['rg'],
	\ 'default_opts': [
	\   '--vimgrep'
	\ ],
	\ 'recursive_opts': [],
	\ 'pattern_opt': [],
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
  let ignore_filtype = ["unite", "vimfiler", "vimshell", "nerdtree", "denite", "defx", "qf", "mark_view"]
  return index(ignore_filtype, getbufvar(winbufnr(a:winnr), "&filetype")) != -1
endfunction

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

call denite#custom#action('buffer,directory,file,openable', 'open_with_choosewin', function('OpenWithChoosewin'))

function! DefxOpenWithChoosewin(context)
	let path = a:context.targets[0]
	call s:openWithChoose(path)
endfun

function! DefxSmartOpen(_)
    if defx#is_directory()
		return (defx#call_action('open_tree', 'toggle') . 'j')
        "return defx#is_opened_tree() ?
                "\ defx#call_action('close_tree') : defx#call_action('open_tree')
    else
        return defx#call_action('call', 'DefxOpenWithChoosewin')
    endif
endfunction

function! DefxClose(context)
    if line('.') ==# 1 || line('$') ==# 1
        return defx#call_action('cd', ['..'])
    endif
	return defx#call_action('close_tree')
endfun

call defx#custom#column('icon', {
			\ 'directory_icon': '▸',
			\ 'opened_icon': '▾',
			\ 'root_icon': '≡',
			\ })

" =========================== DeFX =================================
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  set cursorline

  " Movement
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('call', 'DefxSmartOpen')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('call', 'DefxClose')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('call', 'DefxSmartOpen')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('preview')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'

  " editing
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')

  " display
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')

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
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
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
map ,b :Denite -start-filter buffer<CR>
map ,e :Defx -split=vertical -winwidth=40 -direction=topleft<CR>
map ,m :Denite flatmenu -winheight=10 -start-filter -buffer-name=menu<CR>

" -- menu --
let g:dotq_menus = {}

func! DotqUpdateMenus()
	call denite#custom#var('flatmenu', 'menus', g:dotq_menus)
endfunc

let g:dotq_menus.coc = [
	\ [ '[TS] Build results', 'CocCommand tsserver.watchBuild'],
	\ ]

let g:dotq_menus.hector = [
	\ [ 'Open GPT side window', 'OpenHector'],
	\ [ 'Send to GPT', 'AskHector'],
	\ ]

let g:dotq_menus.debug = [
	\ [ 'Breakpoint', 'lua require"dap".toggle_breakpoint()'],
	\ [ 'Continue', 'lua require"dap".continue()'],
	\ [ '[Python] Init debugger', 'call DotqSetupDapPython'],
	\ [ 'Start debugging', 'Dap'],
	\ [ 'Stop debugging', 'DapStop'],
	\ ]

let g:dotq_menus.other = [
	\ [ 'Color scheme to Vifm', 'call vifm#colorconv#convert()' ],
	\]


func! s:to_cmd(item)
  return [a:item, 'colorscheme ' . a:item]
endfunc

let g:dotq_menus.colors = map([
      \ 'madeofcode', 'pink-moon', 'hydrangea', 'japaneque', 'pulumi', 'tender', 'everforest', 'nord',
      \ 'aurora', 'miramare', 'luna', 'gotham', 'deus', 'rootwater', 'rigel', 'deus', 'ayu', 'pencil',
        \ 'lyla', 'madrid', 'kanagawa', 'nightfox', 'nightfly', 
        \ 'tokyonight', 'tokyonight-storm', 'tokyonight-day', 'tokyonight-night', 'tokyonight-moon',
		\ 'ghostbuster', 'mod8', 'metalheart', 'catppuccin', 'catppuccin-frappe', 'catppuccin-macchiato',
		\ 'catppuccin-mocha', 'bamboo', 'starry', 'newpaper', 'dogrun', 'iceberg', 'melange',
      \], 's:to_cmd(v:val)')

let g:dotq_menus.lightcolors = map([
			\ 'tokyonight-day', 'catppuccin-latte', 'soda', 'proton'
      \], 's:to_cmd(v:val)')

call DotqUpdateMenus()
