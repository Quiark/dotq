call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'

" Make sure you use single quotes
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-easy-align'

" Using git URL
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

Plug 'https://github.com/Shougo/unite.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'ujihisa/unite-colorscheme'
Plug 'osyo-manga/unite-filetype'
Plug 'osyo-manga/unite-quickfix'
Plug 'nielsmadan/harlequin'
Plug 'bling/vim-airline'
Plug 'tsukkee/unite-tag'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/syntastic'
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}
Plug 'ervandew/supertab'



" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }


call plug#end()


" Neovim only
tnoremap <Esc> <C-\><C-n>


set t_vb=


" Diff {{{1
set diffopt=filler,iwhite
set diffexpr=MyDiff()
function MyDiff()
  let opt = '-B '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  silent execute '!diff -a ' . opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
endfunction


" Basic settings {{{1
filetype plugin on
set nocompatible
source $VIMRUNTIME/vimrc_example.vim

syntax enable
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
let c_comment_strings=1
set nowrap
set nobackup
set nowritebackup
set autoindent
set guioptions=gmrLt
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase

set formatoptions=roql
set textwidth=0
let g:DirDiffDynamicDiffText = 1


set grepprg=ack-grep

set fileencodings=ucs-bom,utf-8
setglobal fileencoding=utf-8
set wmh=0

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" turn off the bell
set vb
set t_vb=

" pismena s diakritikou jsou taky slova
set isk=@,48-57,_,128-167,181,193,200-253

" Sometimes we edit C++ templates with Vim
set matchpairs=(:),[:],{:},<:>

nnoremap ; :

" Extra handy mappings {{{1
imap <F2> <><Esc>i
imap <F3> </a><Esc>hcl
imap <F4> </><Esc>hi

map <F8> :cn<CR>




" Maps ,g to find the word under the cursor
map ,g :grep '<cword>' *.cpp *.h *.py <CR>:copen<CR>


" move to first capital letter (for CamelCase)
map ,f /[A-Z_]<CR>

map! <C-Space> <esc>

set lcs=tab:>-,eol:<,nbsp:%
" Windows navigation {{{1
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <C-_> <C-W><C-_><C-W><Bar>
map <F7> <C-W><C-=>




let g:alternateExtensions_CPP = "inc,h,H,HPP,hpp,cc,hh"
let g:alternateExtensions_CC = "hh"
let g:alternateExtensions_HH = "cpp,cc"

"  Menu items {{{1
menu &Plugin.Scons.Latex\ template :!python -m my_scons --setup-latex<CR>
menu &Plugin.&Switch :A<CR>
menu &Plugin.&Colors.Mustang :runtime worth_colors/mustang.vim<CR>
menu &Plugin.&Colors.Lucius :color lucius<CR>
menu &Plugin.&Colors.Sand :runtime worth_colors/sand.vim<CR>
menu &Plugin.&Colors.Paintbox :runtime worth_colors/paintbox.vim<CR>
menu &Plugin.&Colors.Neverness :runtime worth_colors/neverness.vim<CR>
menu &Plugin.&Colors.Sift :runtime worth_colors/sift.vim<CR>
menu &Plugin.&Colors.Twilight :runtime worth_colors/twilight.vim<CR>
menu &Plugin.&Colors.Darkspectrum :runtime worth_colors/darkspectrum.vim<CR>
menu &Plugin.&Colors.Molokai :runtime worth_colors/molokai.vim<CR>
menu &Plugin.&Colors.ir_white :runtime worth_colors/ir_white.vim<CR>
menu &Plugin.&Colors.Northland :runtime worth_colors/northland.vim<CR>
menu &Plugin.&Colors.Guepardo :runtime worth_colors/guepardo.vim<CR>
menu &Plugin.&Colors.Zmrok :runtime worth_colors/zmrok.vim<CR>
menu &Plugin.&Colors.Bog :color bog<CR>
menu &Plugin.&Colors.ColorZone :color colorzone<CR>
menu &Plugin.&Colors.Two2Tango :color two2tango<CR>
menu &Plugin.&Colors.TuttiColori :color tutticolori<CR>

"  Tags {{{1
set tags=tags,../tags
let g:ctags_cpp_opts = "--c++-kinds=+p --fields=+iaS --extra=+q --languages=c++"
func! MkTags()
    exe 'silent !ctags '. g:ctags_cpp_opts .' -R *'
endfun


" Ctrl-] doesn't work on my dvorak keyboard, so use ,t
map ,t <C-]>

map ,<space> :tn<CR>
map ,<bs> :tp<CR>


" Unite {{{1

let g:unite_source_grep_command = 'ack'
let g:unite_source_grep_default_opts = '--no-heading --no-color -H'
let g:unite_source_grep_recursive_opt = ''
"let g:unite_source_rec_async_command = 'notepad'
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
map ,a :Unite -start-insert grep:.<CR>
map ,p :Unite file -start-insert<CR>
map ,b :Unite buffer -start-insert<CR>
map ,n :Unite tag -start-insert<CR>

