#!/bin/sh
# arg 1 : user@machine

scp `dirname $0`/aliases.sh $1:/tmp/
scp `dirname $0`/aliases.fish $1:/tmp/

ssh $1 sudo mv /tmp/aliases.sh /etc/profile.d/
ssh $1 sudo mkdir -p /etc/fish/conf.d/
ssh $1 sudo mv /tmp/aliases.fish /etc/fish/conf.d/
