#set -x JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home/
# this breaks man, it needs to contain all paths
# set -x MANPATH ~/Documents/man

set -x DOTQ_HOME ~/git/dotq

# to support 'nix-shell --pure' usage with fish
if [ $PATH[1] = '/usr/local/bin' ]
    # normal case -- add
    set -x PATH ~/.nix-profile/bin /nix/var/nix/profiles/default/bin $PATH $HOME/.cargo/bin
end
#set -x NIX_PATH nixpkgs=/nix/var/nix/profiles/per-user/roman/channels/nixpkgs

# bad iTerm2 thinks it's smarter than me
set -e LC_CTYPE
set -e LC_NUMERIC
set -x LANG 'en_US.UTF-8'
set -x BROWSER none
set -x REACT_EDITOR echo
# NOTE: the ack warnings about LC_NUMERIC .. actually Unite filter matcher_fuzzy does that

ulimit -n 1024 # any normal project will hit the 256 limit

if [ (whoami) = 'root' ]
	set --global hydro_color_pwd red
else
	set --global hydro_color_pwd green
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

function _venv_update_prompt
	# Save the current fish_prompt function as the function _old_fish_prompt.
    functions -c fish_prompt _venv_old_fish_prompt

    # With the original prompt function renamed, we can override with our own.
    function fish_prompt
		set name (basename $DIRENV_ROOT)

        # Save the return status of the last command.
        set -l old_status $status

        # Output the venv prompt; color taken from the blue of the Python logo.
        printf "%s%s%s" (set_color 4BBE8E) ":$name: " (set_color normal)

        # Restore the return status of the previous command.
        echo "exit $old_status" | .
        # Output the original/"old" prompt.
        _venv_old_fish_prompt
    end

end

function _venv_maybe_reload --on-event fish_prompt
	if [ -n "$DIRENV_FILE" ] 
		set time (stat -c %Y $DIRENV_FILE)
		if [ $time -gt $DIRENV_MTIME ]
			source $DIRENV_FILE
			echo (set_color 4BBEE8) "Reloaded env" (set_color 4BBE8E) (basename $DIRENV_ROOT)
			set -gx DIRENV_MTIME $time
		end
	end
end

# load environment for current folder
#  either python venv
#  or fish env.fish
#  TODO show current direnv in prompt ,kinda like python venv
function venv
	set PATH_OPTIONS '.' (git rev-parse --show-toplevel)
	for TRYPATH in $PATH_OPTIONS
	  if test -e $TRYPATH/env.fish
		  set -gx DIRENV_ROOT (realpath $TRYPATH)
		  source $TRYPATH/env.fish
		  set -gx DIRENV_MTIME (stat -c %Y $TRYPATH/env.fish)
		  set -gx DIRENV_FILE (realpath $TRYPATH/env.fish)
		  _venv_update_prompt $TRYPATH
		  return
	  end
	  # TODO deprecate env.fish

	  if test -e $TRYPATH/direnv.fish
		  set -gx DIRENV_ROOT (realpath $TRYPATH)
		  source $TRYPATH/direnv.fish
		  set -gx DIRENV_MTIME (stat -c %Y $TRYPATH/direnv.fish)
		  set -gx DIRENV_FILE (realpath $TRYPATH/direnv.fish)
		  _venv_update_prompt $TRYPATH
		  return
	  end

	  # Python venv
	  if set -q $argv[1]
		  set name env
	  else
		  set name $argv[1]
	  end

	  set ACT $TRYPATH/$name/bin/activate.fish
	  if test -e $ACT
		set -gx DIRENV_ROOT (realpath $TRYPATH)
		source $ACT
		return
	  end
	end
end

function py3stuffenv
	source ~/install/py3stuff/bin/activate.fish
end

function dotpdf
	set name $argv[1]
	dot -Tpdf $name.dot -o $name.pdf
	open $name.pdf
end

# This is for Voltron, for use with get-cookie.sh
# TODO put get-cookie here so it can be used for other projects
# TODO make script that parses key=val, key1=val2 into JSON
function carl
	set path $argv[1]
	set CSRF (grep X-CSRF-TOKEN curl_login.txt | tr -d '\n\r')
	curl -b curl_cookies.txt $PROXY -H "$CSRF" -H 'Content-type: application/json' $URL/$path $argv[2..-1] | tee curl_last.txt | jq
end

function carl_login
	if set -q URL; and set -q USERNAME; and set -q PASSWORD
		# ok
	else
		echo Need to set \$URL, \$USERNAME, \$PASSWORD
	end
	curl $URL/login -X POST $PROXY --data '{"username":"'$USERNAME'", "password":"'$PASSWORD'"}' -H 'Content-Type:application/json' -c curl_cookies.txt -i -s | tee curl_login.txt
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
			echo TODO
			# TODO search for a path matching regex
			# print it and also save to (global?) variable so it can be easily used
		case help
			echo "laul [list | restart | help | findp]"
			echo " ---"
			echo "launchctl cheatsheet:"
			echo "launchctl load|unload <filename>"
			echo "launchctl start|stop <label>"
	end
end

alias ku kubectl

# override this builtin function because calling svn is expensive
function fish_svn_prompt
end
# slows down command tab completion
function __fish_describe_command
end

function run_grafana
	# installed using nix
	# BTW had to manully link from .nix-profile/share/grafana to ~/.grafana
	grafana-server -homepath ~/.grafana
end

set -x HLP_COMMANDS 'hlp:print the help'
function hlp_register
    set cmd $argv[1]
    set desc $argv[2]

	set ix 1
	for i in $HLP_COMMANDS
        set vars (string split -m 1 : $i)
		if [ "$vars[1]" = "$cmd" ]
			set -e HLP_COMMANDS[$ix]
			break
		end
		set ix (math $ix + 1)
	end
    set -x HLP_COMMANDS $HLP_COMMANDS $cmd:"$desc"
end

function hlp
    for i in $HLP_COMMANDS
        set vars (string split -m 1 : $i)
        set_color red; echo -n $vars[1]
        set_color yellow; echo -n ' :: '
        set_color normal; echo $vars[2]
    end
end


hlp_register tabtitle 'Set the title of the current tab in iTerm2'
function tabtitle
  # BTW need to configure this trigger in iTerm
  # regex: \\033]0;([a-z_-]+)\\007
  # uncheck use interpolated strings
  echo '\033]0;'$argv'\007'
end

hlp_register new_tmux_session 'Create a new tmux session with the given name'
function new_tmux_session
  tabtitle $argv
  tmux new-session -s $argv
end

function vifm
	set -x TERM xterm-direct
	~/.nix-profile/bin/vifm $argv
end

hlp_register minop_deploy 'Deploy minop scripts to target machine'
function minop_deploy
  ~/git/dotq/tools/minop/upload.sh $argv
end

function poetry
    # because can't install it as a standalone binary with nixpkgs
    # so make an alias
    ~/install/py3_11stuff/bin/poetry $argv
end

function debuggy_py
  ~/install/py3stuff/bin/python -m debugpy --listen localhost:5678 $argv
  # 19737
end

function debuggy_rust
  ~/install/codelldb/adapter/codelldb --port 13000
end

hlp_register debuggy 'Control DAP based debuggers'
function debuggy
  switch $argv[1]
    case py
      debuggy_py $argv[2..-1]
    case rust
      debuggy_rust $argv[2..-1]
    case '*'
      echo "Usage:"
      echo "debuggy py script.py"
      echo "debuggy rust"
  end
end
