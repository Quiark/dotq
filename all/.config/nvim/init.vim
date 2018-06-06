call plug#begin('~/.vim/plugged')

command -nargs=+ Plugin Plug <args>


" Make sure you use single quotes
Plug 'junegunn/seoul256.vim'
"Plug 'junegunn/vim-easy-align'

" Using git URL
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

Plug 'osyo-manga/unite-filetype'
Plug 'nielsmadan/harlequin'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/syntastic'
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}
"Plug 'ervandew/supertab'
Plug 'dag/vim-fish'
Plug 'tomlion/vim-solidity'
"Plug 'critiqjo/lldb.nvim'
Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'keith/parsec.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-scripts/proton'
Plug 'daddye/soda.vim'
Plug 'leafgarland/typescript-vim'
"Plug 'ternjs/tern_for_vim'
Plug 'derekwyatt/vim-scala'
Plug 'jceb/vim-orgmode'
Plug 'FStarLang/VimFStar'
Plug 'vim-airline/vim-airline-themes'
Plug 'hkupty/iron.nvim'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'udalov/kotlin-vim'
Plug '~/Devel/fstarry'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'pangloss/vim-javascript'

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Comment this out to make PlugInstall work fine again :/
source $DOTQ_HOME/all/.config/vim/dotq/plugins.vim
call plug#end()

" can be used for debugging
" let g:python_host_prog = '/Users/roman/syspython2'
" let g:python3_host_prog = '/Users/roman/python3'

let g:fstar_path = 'mono ~/Software/FStar/bin/fstar.exe'

" Neovim only
tnoremap <Esc> <C-\><C-n>

let g:fstar_path = 'mono ~/Projects/FStar/bin/fstar.exe'

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

source $DOTQ_HOME/all/.config/vim/dotq/base.vim
source $DOTQ_HOME/all/.config/vim/dotq/tags.vim


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


source $DOTQ_HOME/all/.config/vim/dotq/unite.vim

" use global tern install
let tern#command=['tern']
