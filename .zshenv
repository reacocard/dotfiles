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

# give sudo prompt matching colors to zsh prompt
export SUDO_PROMPT=$'\e[31m[sudo]\e[0m password for \e[32m\e[1m%p\e[0m@\e[1m\e[35m%H\e[0m: '

if [ x"$XDG_SESSION_TYPE" = x"wayland" ]; then
    QT_QPA_PLATFORM="wayland;xcb"
    GDK_BACKEND=wayland
    MOZ_ENABLE_WAYLAND=1
fi

# Unset GUI vars in multiplexers since they don't stay attached to the session.
if [[ $TERM == screen* ]] || [[ $TERM == tmux* ]]; then
    unset DESKTOP_SESSION
    unset DISPLAY
    unset GDMSESSION
    unset MOZ_ENABLE_WAYLAND
    unset SESSION_MANAGER
    unset WAYLAND_DISPLAY
    unset XAUTHORITY
    unset XDG_CURRENT_DESKTOP
    unset XDG_MENU_PREFIX
    unset XMODIFIERS
    unset -m 'GDK_*'
    unset -m 'GDM_*'
    unset -m 'GNOME_*'
    unset -m 'GSM_*'
    unset -m 'GTK_*'
    unset -m 'QT_*'
    unset -m 'VTE_*'
    unset -m 'XDG_SESSION_*'
fi

export KR_SKIP_SSH_CONFIG=1

export RSYNC_PROTECT_ARGS=1

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
