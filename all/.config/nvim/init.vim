
luafile $DOTQ_HOME/all/.config/nvim/dotq/config.lua
" luafile $DOTQ_HOME/all/.config/nvim/dotq/plugins.lua

source $DOTQ_HOME/all/.config/vim/dotq/denite.vim
source $DOTQ_HOME/all/.config/nvim/dotq/debugging.vim

" can be used for debugging
" let g:python_host_prog = '/Users/roman/syspython2'
" TODO need /usr/local/bin/python3 for macOS, something else on windows
" TODO dont use this any more, nvim from Nix brings its own
"let g:python3_host_prog = '/usr/local/bin/python3'

let g:fstar_path = 'mono ~/Software/FStar/bin/fstar.exe'

set t_vb=
set noequalalways

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

let g:choosewin_overlay_enable = 0

"  Menu items {{{1
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
