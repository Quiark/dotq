#!/bin/sh
# arg 1 : user@machine
scp aliases.sh $1:/etc/profile.d/
scp aliases.fish $1:/etc/fish/conf.d/
