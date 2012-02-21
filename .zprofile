
# FreeBSD puts ~/bin at the end of the path by default. Ick.
PATH=`echo $PATH | sed "s/:\/home\/$USER\/bin//"`

ZSH_NULL=$(setopt | grep "nullglob")
setopt nullglob
PATHS=(/usr/games $HOME/.opt/*/bin $HOME/.cabal/bin $HOME/.local/bin $HOME/bin)
for p in $PATHS; do
    if [[ -d $p ]] && [[ $PATH != *$p* ]]; then
        export PATH="$p:$PATH"
    fi
done
if [ ! -z $ZSH_NULL ]; then
    unsetopt nullglob
fi

export EXAILE_NO_OPTIMIZE=1
export EDITOR=vim
export PAGER=less
export LANG=en_US.utf-8
export OOO_FORCE_DESKTOP=gnome
export DESKTOP_SESSION=gnome
export TZ=America/Los_Angeles
export LANG=en_US.UTF-8

# less colors for manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;35m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ -f "$HOME/.zprofile.local" ] ; then
    . $HOME/.zprofile.local
fi

