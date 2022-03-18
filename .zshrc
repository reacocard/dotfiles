# zsh configuration file
# vim: et sts=4 ts=4

### IMPORTS ###

source $HOME/.zsh/mouse.zsh

source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

autoload -U add-zsh-hook

### BASICS ###

# Enable zmv - powerful alt to mv
autoload -U zmv

# Make it pretty
autoload -U colors
colors

# Kill the stupid beeping
unsetopt beep

# log out idle login shells. this helps mitigate the case where i opened a VT
# to fix something and forgot to come back to logout.
if [[ -o login ]]; then
    export TMOUT=300  # five minutes
else
    export TMOUT=0
fi

### COMPLETION ###

# Attempt to correct typos
setopt correct

# Cd into a dir that is entered directly on the prompt
setopt autocd

# Moar globbing power
setopt extended_glob

setopt autolist

zstyle :compinstall filename '/home/reacocard/.zshrc'
autoload -U compinit
compinit
setopt complete_in_word


setopt completealiases

if [ -f $HOME/.ssh/known_hosts ]; then
    local knownhosts
    knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
    zstyle ':completion:*:(ssh|scp|sftp|rsync):*' hosts $knownhosts
fi

if [[ -x `which dircolors` ]]; then
    # Make ls have pretty colors, but skip the file-extension-specific ones.
    eval $(dircolors <(dircolors --print-database | egrep -v '^\.[^ ]+'))
fi
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


### KEYMAP ###

# Load escape sequences for keys from terminfo

typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[Backspace]=${terminfo[kbs]}
key[Delete]=${terminfo[kdch1]}
key[Shift]=
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" history-substring-search-up
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" history-substring-search-down
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char

# make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

bindkey -M emacs '\em' zle-toggle-mouse
bindkey -M vicmd M zle-toggle-mouse

### HISTORY ###

# Set history file location and size
HISTFILE=~/.zshhist
HISTSIZE=100000
SAVEHIST=100000

# Use better locking
setopt histfcntllock

# Skip duplicates
setopt histfindnodups

# Append to histfile instead of overwriting it
setopt appendhistory 

# Add items to the histfile as they are entered instead of on exit
setopt incappendhistory

# Don't add lines that start with a space to the history
setopt histignorespace

# Verify history substitutions before executing
setopt histverify


### PROMPT ###

# parts of the following adapted from http://aperiodic.net/phil/prompt/

PR_REMOTE_CLIENTNAME=""
_PR_IP_HOST="unset"
_PR_RUNNING=0
_PR_CUR_CMD=""

running_cmd_preexec () {
   _PR_CUR_CMD="$(echo $1 | sed -E 's/(^|.*[[:space:]])([^=[:space:]]+)([[:space:]].*|$)/\2/')"
   _PR_RUNNING=1
   update_titlebar
}
add-zsh-hook preexec running_cmd_preexec

running_cmd_precmd () {
    _PR_RUNNING=0
    update_titlebar
}
add-zsh-hook precmd running_cmd_precmd

update_titlebar () {
    local _PR_CMD=""
    if [ x$_PR_CUR_CMD != x"" ]; then
        if [ $_PR_RUNNING -eq 1 ]; then
            _PR_CMD="${_PR_CUR_CMD} | "
        else
            _PR_CMD="${_PR_CUR_CMD}* | "
        fi
    fi

    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)${_PR_CMD}%n@%m${PR_REMOTE_CLIENTNAME}:%~\a%}'

    print -Pn "$PR_TITLEBAR"
}

setprompt () {
    setopt prompt_subst

    PR_PREFIX=""
    ###
    # Decide whether to set a screen title
    if [[ $TERM == screen* ]]; then
        PR_STITLE=$'%{\ekzsh %~\e\\%}'
        if [[ -n "$TMUX" ]]; then
            PR_PREFIX="${PR_PREFIX}[tmux] "
        else
            PR_PREFIX="${PR_PREFIX}[screen] "
        fi
    else
	    PR_STITLE=''
    fi


    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

    # Get the name of the machine we're sshed in from.
    if [ -n "$SSH_CLIENT" ]; then
        PR_REMOTE_CLIENTNAME="$(echo ${SSH_CLIENT} | cut -d\  -f 1)"
        if [ x$_PR_IP_HOST = x"unset" ]; then
            if which dig > /dev/null && which timeout > /dev/null; then
                set -o pipefail
                _PR_IP_HOST=`timeout -k 1s 2s dig -x "$PR_REMOTE_CLIENTNAME" +short +timeout=1 | sed s/\.$//` || _PR_IP_HOST=""
            else
                _PR_IP_HOST=""
            fi
        fi
        if [ x$_PR_IP_HOST != x"" ]; then
            PR_REMOTE_CLIENTNAME="$_PR_IP_HOST($PR_REMOTE_CLIENTNAME)"
        fi
        PR_REMOTE_CLIENTNAME_COLOURED="$PR_NO_COLOUR|$PR_BLUE${PR_REMOTE_CLIENTNAME}"
        PR_REMOTE_CLIENTNAME="|${PR_REMOTE_CLIENTNAME}"
        PR_PREFIX="${PR_PREFIX}[ssh] "
    fi

    update_titlebar
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_STITLE$PR_PREFIX%(!.$PR_RED.$PR_GREEN)%n$PR_NO_COLOUR@$PR_MAGENTA%m$PR_REMOTE_CLIENTNAME_COLOURED$PR_NO_COLOUR:$PR_CYAN%~$PR_NO_COLOUR\

%(?.$PR_LIGHT_GREEN.$PR_LIGHT_RED)%?$PR_NO_COLOUR%# '
}

setprompt


cmd_timer_preexec () {
    _CUSTOM_TIME_START=$SECONDS
}
add-zsh-hook preexec cmd_timer_preexec

cmd_timer_precmd () {
    # Print runtime of long-running commands.
    if [ -n "$_CUSTOM_TIME_START" ]; then
        local elapsed=$(($SECONDS - $_CUSTOM_TIME_START));
        _CUSTOM_TIME_START='';
        if [ $elapsed -ge 30 ]; then
            local seconds=$(($elapsed % 60));
            local minutes=$((($elapsed / 60) % 60));
            local hours=$(($elapsed / 3600));
            printf "[zsh] Elapsed time %02i:%02i:%02i.\n\a" $hours $minutes $seconds;
        fi;
    fi;
}
add-zsh-hook precmd cmd_timer_precmd


### ALIASES ###

# These options are newish but make copies nicer.
if `/bin/cp --reflink=auto /dev/null /dev/zero >/dev/null 2>&1`; then
    alias cp='cp --reflink=auto'
fi

# FreeBSD's ls doesn't support --color :( :( :(
if `/bin/ls --color > /dev/null 2>&1`; then
    alias ls='ls --color=auto'
fi

# Stop GNU tar using rsh on :-containing filenames
if `/bin/tar --force-local -c /dev/null > /dev/null 2>&1`; then
    alias tar='tar --force-local'
fi

# pretty colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# no gui
alias mtr='mtr -t'

# allow root shell to detect ssh
alias sudo='sudo --preserve-env=SSH_CLIENT'

# vim is a hard habit to break
alias :q='exit'

# set operations for sorted files
alias fsetdiff='comm -23'
alias fsetintersection='comm -12'
alias fsetunion='comm --output-delimiter=""'

# Launch, background, disown, and ignore output of a command
# TODO: Add zsh completion
l() { $* >&! /dev/null &! }

hist() { grep $* ~/.zshhist }


### INFO ###

if (cd $HOME && [ -e .git/HEAD ] && git status | grep "Your branch is behind" > /dev/null); then
  echo "There are dotfiles updates to apply."
fi


### LOCAL CONFIG ###

if [ -f ~/.zshrc-local ]; then
    source ~/.zshrc-local
fi
