### PATH MANAGEMENT ###

ZSH_NULL=$(setopt | grep "nullglob")
setopt nullglob
PATHS=(/sbin /usr/sbin /usr/local/sbin /usr/games /var/lib/flatpak/exports/bin $HOME/.opt/*/bin $HOME/.cabal/bin $HOME/.gem/ruby/*/bin $HOME/.cargo/bin $HOME/.local/bin $HOME/bin)
for p in $PATHS; do
    if [[ -d $p ]] && [[ $PATH != *$p* ]]; then
        export PATH="$p:$PATH"
    fi
done
if [ ! -z $ZSH_NULL ]; then
    unsetopt nullglob
fi


### ENVIRONMENT VARIABLES ###

export EDITOR=vim
export PAGER=less
export LANG=en_US.UTF-8

# less colors for manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;35m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Unset $DISPLAY in screen, since it doesn't work well
if [[ "$TERM" == "screen" ]]; then
    DISPLAY=""
fi

export KR_SKIP_SSH_CONFIG=1
