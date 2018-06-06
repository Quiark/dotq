set -x JAVA_HOME (/usr/libexec/java_home)
# this breaks man, it needs to contain all paths
# set -x MANPATH ~/Documents/man
set -x TOOLBOX ~/Projects/CordaPerformance/scripts/

# local Perl config
set -x PATH /Users/roman/perl5/bin $PATH ^/dev/null;
set -q PERL5LIB; and set -x PERL5LIB /Users/roman/perl5/lib/perl5:$PERL5LIB;
set -q PERL5LIB; or set -x PERL5LIB /Users/roman/perl5/lib/perl5;
set -q PERL_LOCAL_LIB_ROOT; and set -x PERL_LOCAL_LIB_ROOT /Users/roman/perl5:$PERL_LOCAL_LIB_ROOT;
set -q PERL_LOCAL_LIB_ROOT; or set -x PERL_LOCAL_LIB_ROOT /Users/roman/perl5;
set -x PERL_MB_OPT --install_base\ \"/Users/roman/perl5\";
set -x PERL_MM_OPT INSTALL_BASE=/Users/roman/perl5;

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

# does not work
function cor
	fish $TOOLBOX/cor_session.fish $argv
end

function tlc_cluster
	fish $TOOLBOX/tlc_cluster.fish $argv
end

function vim_tlc
	vimr --nvim -S ~/Projects/TLC/session.vim
end

function vim_fstar
	vimr --nvim -S ~/Devel/fstarvim/session.vim
end

function vim_voltron_old
	cd ~/Projects/hsbc_voltronx/voltronx-cordapp/
	vimr 
end
