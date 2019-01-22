% ft=markdown

# Vim

## VimFiler

- `,e`  Open VimFilerEx
- `v`  Preview file
- `.`  Show dot files

- `gc`  Set vim PWD (for VimFiler window only)
- `&`  Go to project dir

## Unite

- `,b`  Select a buffer
- `,n`  Select a tag

## Debug and Diagnose

- `'verbose', 'verbosefile'`
- `:au`
- `let xy=execute('au')`  To grab the output

## Colors

- `call RescueSyntaxPython()` to fix colors after changing color schemes (defined in `plugin/rescue.vim`)

# tmux

- `set -g prefix ``   Set different prefix key
- `source-file ~/.tmux.conf`  Reload config
- in "copy mode", use <Ctrl-S> to search down and <Ctrl-R> to search up
- if accidentally pressed `Ctrl-S`, unstuck by pressing `Ctrl-Q`
- run `tmux -2` to enable 256 color vim
- `setw -g mode-keys vi` to set Vim mode

# Powershell

- `venv x`  Activate virtualenv in directory `x`
- `Dotq-Edit`  Open editor for dotq files


# git

- `git fetch` && `git checkout`    Seems to work to work on a remote branch.

### git log simplification
 
- want to display meaningful branching history in terminal, need to explore what git log provides

# weechat

- compile on osx
	doesnt work: `brew install weechat --with-perl --with-python --with-lua --with-curl`
	download sources, config cmake options manually (without yaml, ruby), compile -> works

	set -x LUA_PATH (luarocks path --lr-path)
	set -x LUA_CPATH (luarocks path --lr-cpath)
