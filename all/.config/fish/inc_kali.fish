if test (hostname) != kali
	exit 
end


set -x WORDS /usr/share/wordlists
set -x EXPLOITS /usr/share/exploitdb/platforms/
set -x METASPLOIT /usr/share/metasploit-framework/modules
set -x NMAP /usr/share/nmap/scripts
set -x DATA ~/Dropbox/OSCP
set -x LHOST 192.168.45.31

# TODO
function audit_cmds  #--on-event fish_preexec
	set OUT ~/log/history.txt
	# command line
	echo cmd: $argv >> $OUT
	# this is PID
	echo pid: %self >> $OUT
	echo now: (date) >> $OUT
	echo pwd: (pwd) >> $OUT
	echo --- >> $OUT
end

function exploit-gcc
	set NAME $argv
	/usr/local/musl/bin/musl-gcc -static -o $NAME $NAME.c -I/root/Downloads/kernel-headers/i386/include
	cp $NAME ~/Public/
end

# Prepares exploit by id from clipboard
function exploit-pick
	set NAME (xclip -o)
	cp $EXPLOITS/linux/local/$NAME.* ~/Dropbox/OSCP/compiled
	less ~/Dropbox/OSCP/compiled/$NAME.*
	echo $NAME
end

function my-dirbuster
	dirbuster -u http://$TGT -l ~/Dropbox/OSCP/directory-list-2.3-small.txt
end

