## TODO ##

* stow can be layered so let's reuse config from Linux on OSX too (but need to exclude some Linux specific stuff)
	* TODO: put common vim config in `all/.config/vim/dotq` separated by topic


* TODO: how to not stow inc_alekto.fish etc.?
* TODO: create stow commands for each environment
	it's also a function in ~/.config/fish/inc_* but not available before stow ;)
	`cd ~/git/dotq && stow -t ~ -v all`
