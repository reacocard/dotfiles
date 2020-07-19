# zsh configuration file
# vim: et sts=4 ts=4

### IMPORTS ###

if [ -f $HOME/.cargo/env ]; then
    source $HOME/.cargo/env
fi

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
    eval $(dircolors)
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

if
    # These terms are only sometimes linked against ncurses. If they aren't,
    # applying this hack will break them, so we need to detect the linkage.
    ([[ $TERM == screen* ]] && ldd `which screen` | grep ncurses > /dev/null) ||
    ([[ $TERM == tmux* ]] && ldd `which tmux` | grep ncurses > /dev/null)
then
    # $terminfo[] entries are weird in ncurses application mode...
    for k in ${(k)key} ; do
        [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
    done
    unset k
fi

[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" history-beginning-search-backward
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" history-beginning-search-forward
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char


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


### PROMPT ###

# parts of the following adapted from http://aperiodic.net/phil/prompt/

_PR_IP_HOST="unset"

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

    PR_REMOTE_CLIENTNAME=""
    # Get the name of the machine we're sshed in from.
    if [ -n "$SSH_CLIENT" ]; then
        PR_REMOTE_CLIENTNAME="$(echo ${SSH_CLIENT} | cut -d\  -f 1)"
        if [ x$_PR_IP_HOST = x"unset" ]; then
            if which dig > /dev/null; then
                _PR_IP_HOST=`dig -x "$PR_REMOTE_CLIENTNAME" +short +timeout=1 | sed s/\.$//`
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

    ###
    # Decide if we need to set titlebar text.
    case $TERM in
	    xterm*|rxvt*)
	        PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m${PR_REMOTE_CLIENTNAME}:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	        ;;
	    screen)
	        PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m${PR_REMOTE_CLIENTNAME}:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	        ;;
	    *)
	        PR_TITLEBAR=''
	        ;;
    esac
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_STITLE${(e)PR_TITLEBAR}$PR_PREFIX%(!.$PR_RED.$PR_GREEN)%n$PR_NO_COLOUR@$PR_MAGENTA%m$PR_REMOTE_CLIENTNAME_COLOURED$PR_NO_COLOUR:$PR_CYAN%~$PR_NO_COLOUR\

%(?.$PR_LIGHT_GREEN.$PR_LIGHT_RED)%?$PR_NO_COLOUR%# '
}

setprompt


preexec () {
    _CUSTOM_TIME_START=$SECONDS
}

precmd () {
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


### ALIASES ###

# These options are newish but make copies nicer.
if `/bin/cp --reflink=auto --sparse=always 2>&1 | head -n1 | grep -v '\-\-' > /dev/null 2>&1`; then
    alias cp='cp --reflink=auto --sparse=always'
fi

# FreeBSD's ls doesn't support --color :( :( :(
if `/bin/ls --color > /dev/null 2>&1`; then
    alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias mtr='mtr -t'  # NO GUI

alias :q='exit'

# Launch, background, disown, and ignore output of a command
# TODO: Add zsh completion
l() { $* >&! /dev/null &! }

hist() { grep $* ~/.zshhist }


### INFO ###

if (cd $HOME && git status | grep "Your branch is behind" > /dev/null); then
  echo "There are dotfiles updates to apply."
fi


### LOCAL CONFIG ###

if [ -f ~/.zshrc-local ]; then
    source ~/.zshrc-local
fi
