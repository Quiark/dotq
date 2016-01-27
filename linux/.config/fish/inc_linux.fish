set -x DOTQ_HOME ~/git/dotq

function dotq_stow
    stow -t ~ $DOTQ_HOME/linux
end
