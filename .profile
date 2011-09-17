# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.cabal/bin" ] ; then
    export PATH="$HOME/.cabal/bin:$PATH"
fi

if [ -d "$HOME/local/bin" ] ; then
    export PATH="$HOME/local/bin:$PATH"
fi

if [ -d "/usr/games/" ] ; then
	export PATH="$PATH:/usr/games"
fi

if [ -f "$HOME/.opt/paths-include" ] ; then
    . $HOME/.opt/paths-include
fi

export EXAILE_NO_OPTIMIZE=1
export EDITOR=vim
export LANG=en_US.utf-8
export OOO_FORCE_DESKTOP=gnome
export DESKTOP_SESSION=gnome
export TZ=America/Los_Angeles

# less colors for manpages

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;35m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

mkdir -p ~/.tmp/chromium-cache
mkdir -p ~/.tmp/thumbnails
mkdir -p ~/.tmp/vimswaps


if [ -f "$HOME/.profile.local" ] ; then
    . $HOME/.profile.local
fi

