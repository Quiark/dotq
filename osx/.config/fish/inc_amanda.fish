. ~/Software/virtualfish/virtual.fish
# optional plugins
#. ~/Software/virtualfish/auto_activation.fish
. ~/Software/virtualfish/global_requirements.fish
#. ~/Software/virtualfish/projects.fish


set -x PATH $PATH ~ /opt/local/bin /opt/local/sbin
set -x PATH $PATH ~/depot_tools

set -x LC_ALL C

set -x PYTHONPATH $PYTHONPATH /usr/local/lib/python2.7/site-packages /Users/roman/PyBrowser/overlog

# For importing the lldb module, needed by lldb.nvim
set -x PYTHONPATH $PYTHONPATH /Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Resources/Python
#set -x PATH /Library/Frameworks/Python.framework/Versions/2.7/bin ~/android-sdks/android-ndk-r10/ $PATH
set -x ANDROID_NDK_ROOT ~/android-sdks/android-ndk-r10/

set -x DOTQ_HOME ~/git/dotq
. $DOTQ_HOME/linux/.config/fish/inc_common.fish

function dotq_stow
    stow -t ~ $DOTQ_HOME/osx
end

# Because the new clang-3.6 I instnalled in /usr/local/bin doesnt work by default.
function fix_pip_compiler
    set -x CC /usr/bin/clang
    set -x CXX /usr/bin/clang++
    set -x LDSHARED "/usr/bin/clang -bundle -undefined dynamic_lookup -arch i386 -arch x86_64   -g"
end
