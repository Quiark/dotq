set -x JAVA_HOME (/usr/libexec/java_home)
# this breaks man, it needs to contain all paths
# set -x MANPATH ~/Documents/man
set -x TOOLBOX ~/Projects/CordaPerformance/scripts/

set -x PATH ~/.nix-profile/bin $PATH ^/dev/null;
set -x NIX_PATH nixpkgs=/nix/var/nix/profiles/per-user/roman/channels/nixpkgs /nix/var/nix/profiles/per-user/roman/channels

# bad iTerm2 thinks it's smarter than me
set -e LC_CTYPE
set -e LC_NUMERIC

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

function venv
	# TODO support passing env folder name
	source ./env/bin/activate.fish
end

function dotpdf
	set name $argv[1]
	dot -Tpdf $name.dot -o $name.pdf
	open $name.pdf
end

function carl
	set path $argv[1]
	curl -b curl_cookies $PROXY -H "$CSRF" -H 'Content-type: application/json' $URL/$path $argv[2..-1]
end
