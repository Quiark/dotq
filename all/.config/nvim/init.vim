call plug#begin('~/.vim/plugged')

command -nargs=+ Plugin Plug <args>


" Make sure you use single quotes
Plug 'junegunn/seoul256.vim'
"Plug 'junegunn/vim-easy-align'

" Using git URL
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" the old stuff
"Plug 'osyo-manga/unite-filetype'
"source $DOTQ_HOME/all/.config/vim/dotq/unite.vim

Plug 'nielsmadan/harlequin'
Plug 'flazz/vim-colorschemes'
"Plug 'scrooloose/syntastic'
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}
Plug 'dag/vim-fish'
Plug 'tomlion/vim-solidity'
"Plug 'critiqjo/lldb.nvim'
Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'keith/parsec.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-scripts/proton'
Plug 'daddye/soda.vim'
"Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'
"Plug 'ternjs/tern_for_vim'
Plug 'derekwyatt/vim-scala'
Plug 'jceb/vim-orgmode'
"Plug 'FStarLang/VimFStar'
Plug 'vim-airline/vim-airline-themes'
"Plug 'hkupty/iron.nvim'
"Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'preservim/tagbar'
Plug 'udalov/kotlin-vim'
"Plug '~/Devel/fstarry'
"Plug '~/Devel/mtrepl'
"Plug 'junegunn/rainbow_parentheses.vim'
Plug 'pangloss/vim-javascript'
Plug 'b4b4r07/vim-hcl'
Plug 'jacoborus/tender'
Plug 'posva/vim-vue'
Plug 'LnL7/vim-nix'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'sainnhe/sonokai'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'franbach/miramare'
Plug 'wadackel/vim-dogrun'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'sainnhe/everforest'
Plug 'ayu-theme/ayu-vim'
Plug 'ray-x/aurora'
Plug 'Rigellute/rigel'
Plug 'franbach/miramare'

" The new stuff
Plug 'Shougo/denite.nvim'
Plug 'Shougo/defx.nvim'
Plug 't9md/vim-choosewin'

Plug 'rvmelkonian/move.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug '~/install/vifm.vim'
Plug 'github/copilot.vim'
Plug 'Rigellute/shades-of-purple.vim'

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Comment this out to make PlugInstall work fine again :/
source $DOTQ_HOME/all/.config/vim/dotq/plugins.vim
call plug#end()

source $DOTQ_HOME/all/.config/vim/dotq/denite.vim
source $DOTQ_HOME/all/.config/vim/dotq/coc.vim

" can be used for debugging
" let g:python_host_prog = '/Users/roman/syspython2'
" TODO need /usr/local/bin/python3 for macOS, something else on windows
" TODO dont use this any more, nvim from Nix brings its own
"let g:python3_host_prog = '/usr/local/bin/python3'

let g:fstar_path = 'mono ~/Software/FStar/bin/fstar.exe'

set t_vb=

tmap <Esc> <C-\><C-N>
map <C-C> "+y


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

let g:choosewin_overlay_enable = 1

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


" removes some of airline's slowdowns
let g:airline_highlighting_cache=1

" colors
set termguicolors
color sonokai
