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

if [ x"$XDG_SESSION_TYPE" = x"wayland" ]; then
    QT_QPA_PLATFORM=wayland
    GDK_BACKEND=wayland
    MOZ_ENABLE_WAYLAND=1
fi

# Unset GUI vars in multiplexers since they don't stay attached to the session.
if [[ $TERM == screen* ]] || [[ $TERM == tmux* ]]; then
    unset DESKTOP_SESSION
    unset DISPLAY
    unset MOZ_ENABLE_WAYLAND
    unset SESSION_MANAGER
    unset WAYLAND_DISPLAY
    unset XAUTHORITY
    unset XDG_CURRENT_DESKTOP
    unset XDG_MENU_PREFIX
    unset XMODIFIERS
    unset -m 'GDM*'
    unset -m 'GNOME*'
    unset -m 'GTK*'
    unset -m 'QT*'
    unset -m 'XDG_SESSION_*'
fi

export KR_SKIP_SSH_CONFIG=1
