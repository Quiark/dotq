set -x DOTQ_HOME ~/git/dotq
set -x GOPATH ~/gopath
set -x PATH $PATH $GOPATH/bin

function dotq_stow
    stow -t ~ $DOTQ_HOME/linux
end
