Import-Module PSReadline
#Import-Module Z
#Import-Module posh-git
#import-module powerls
# Load posh-git example profile
#. 'C:\Users\Roman\Local Settings\GitHub\PoshGit_8aecd991d8ccf3dc78b8cd397ee4e1595f8556d4\profile.example.ps1'


function venv { . $args\scripts\activate.ps1 }

$env:GIT_SSH="plink"
$env:DOTQ_HOME="C:\Devel\Projects\dotq"


function Dotq-Edit {
	$ORIG_CD=Get-Location
	cd $env:DOTQ_HOME
	$PS_PROFILE="windows/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
	gvim $PS_PROFILE -S dotq_session.vim
	cd $ORIG_CD
}
