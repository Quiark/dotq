. ~/Software/virtualfish/virtual.fish
# optional plugins
#. ~/Software/virtualfish/auto_activation.fish
. ~/Software/virtualfish/global_requirements.fish
#. ~/Software/virtualfish/projects.fish

set -x GOPATH ~/gopath

set -x PATH $PATH ~/depot_tools $GOPATH/bin

set -x LC_ALL C

set -x PYTHONPATH $PYTHONPATH /usr/local/lib/python2.7/site-packages /Users/roman/PyBrowser/overlog

# For importing the lldb module, needed by lldb.nvim
set -x PYTHONPATH $PYTHONPATH /Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Resources/Python
#set -x PATH /Library/Frameworks/Python.framework/Versions/2.7/bin ~/android-sdks/android-ndk-r10/ $PATH
set -x ANDROID_NDK_ROOT ~/android-sdks/android-ndk-r10/


# For NeoVim
set -x TERM xterm-256color


set -x DOTQ_HOME ~/git/dotq
. $DOTQ_HOME/linux/.config/fish/inc_common.fish

function dotq_stow
    stow -t ~ $DOTQ_HOME/osx
end

# Because the new clang-3.6 I instnalled in /usr/local/bin doesnt work by default.
function fix_pip_compiler
	echo '== Do This =='
    echo set -x CC /usr/bin/clang
    echo set -x CXX /usr/bin/clang++
    echo set -x LDSHARED "/usr/bin/clang -bundle -undefined dynamic_lookup -arch i386 -arch x86_64   -g"
end

function devel_atcipher
	cd ~/Astri/AtCipher/AtOpenSSL
	# doesn't load it into outside environment
	. .roman.fish
	mvim -S .roman.vim
	beefy src/js/ibe_jstester.js 9967
end

function devel_mitmproxy
	# doing a reverse proxy by default, on port 8200
	# $argv[1] will be the target server
	cd ~/Astri/SecShare/GoKeyboard/mitmenv
	. bin/activate.fish
	mitmproxy --port 8200 $argv[1]
end

function dotq_help
	echo Commands are:
	echo  - devel_atcipher
	echo  - devel_mitmproxy
	echo  - dotq_stow
	echo  - fix_pip_compiler
end

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
