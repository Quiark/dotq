set -x JAVA_HOME (/usr/libexec/java_home)
# this breaks man, it needs to contain all paths
# set -x MANPATH ~/Documents/man
set -x TOOLBOX ~/Projects/CordaPerformance/scripts/

set -x PATH ~/.nix-profile/bin $PATH $HOME/.krew/bin  ^/dev/null;
set -x NIX_PATH nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs /nix/var/nix/profiles/per-user/root/channels

# bad iTerm2 thinks it's smarter than me
set -e LC_CTYPE
set -e LC_NUMERIC
set -x LANG 'en_US.UTF-8'

# deprecated
function sshcd
	set to $argv[1]
	set cwd '~'
	switch to
		case 'corda*'
			set cwd /opt/corda
		case 'webserver*'
			set cwd /opt/api/TLC-0.5.1
		case 'notary*'
			set cwd /opt/corda
	end
	ssh -t $to sudo bash -l
end

function cor
	source $TOOLBOX/cor_session.fish
end

function tlc_cluster
	fish $TOOLBOX/tlc_cluster.fish $argv
end


function vim_fstar
	vimr --nvim -S ~/Devel/fstarvim/session.vim
end

function ktlintize
	git diff --name-only | grep '\.kt[s"]\?$' | xargs ktlint -F --relative .
end

function nixupdate
	#echo TODO need to fix this, it updates roots channels but thats different from romans
	# lets not use romans channel
	sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'
end

function zvif
	set name $argv[1]
	set server vifm # TODO

	set result (z --echo $name)
	vifm --server-name $server --remote +"cd \"$result\""
end

function vimr
	/usr/local/bin/vimr --cur-env
end

# load environment for current folder
#  either python venv
#  or fish env.fish
function venv
	if test -e ./env.fish
		source ./env.fish
		return
	end


	# Python venv
	if set -q $argv[1]
		set name env
	else
		set name $argv[1]
	end

	source ./$name/bin/activate.fish
end

function dotpdf
	set name $argv[1]
	dot -Tpdf $name.dot -o $name.pdf
	open $name.pdf
end

# This is for Voltron, for use with get-cookie.sh
function carl
	set path $argv[1]
	set CSRF (grep X-CSRF-TOKEN curl_login.txt | tr -d '\n\r')
	curl -b curl_cookies.txt $PROXY -H "$CSRF" -H 'Content-type: application/json' $URL/$path $argv[2..-1] | tee curl_last.txt | jq
end

function laul
	switch $argv[1]
		case list
			launchctl list | grep -v com.apple
			ll ~/Library/Launch*
			ll /Library/Launch*
		case restart
			launchctl unload -w $argv[2]
			launchctl load -w $argv[2]  # TODO dont run if previous errored
		case findp
			# TODO search for a path matching regex
			# print it and also save to (global?) variable so it can be easily used
	end
end

alias ku kubectl

# override this builtin function because calling svn is expensive
function fish_svn_prompt
end

