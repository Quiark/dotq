" Basic settings {{{1
filetype plugin on
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

syntax enable
set shiftwidth=4
set softtabstop=4
set tabstop=4
set noexpandtab
set guifont=lucida_console:h9:cEASTEUROPE
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


set grepprg=ack

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

" Windows mappings I don't want:
cunmap <C-A>
" really annoying in linux terminal where it's triggered by Shift-Space
inoremap <C-@> <Space>

" Extra handy mappings {{{1
imap <F2> <><Esc>i
imap <F3> </a><Esc>hcl
imap <F4> </><Esc>hi

map <F8> :cn<CR>

" Maps ,g to find the word under the cursor
" New ack doesn't like '<cword>', need to use ""
map ,g :grep "<cword>" <CR>:copen<CR>

set lcs=tab:>-,eol:<,nbsp:%

" Windows navigation {{{1
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
nmap <C-_> <C-W><C-_><C-W><Bar>
map <F7> <C-W><C-=>
