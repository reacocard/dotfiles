# zsh configuration file
# Aren Olson <reacocard@gmail.com>
# vim: et sts=4 ts=4

### BASICS ###

# Enabel zmv - powerful alt to mv
autoload -U zmv

# Make it pretty
autoload -U colors
colors

# Kill the stupid beeping
unsetopt beep

# Unset $DISPLAY in screen, since it doesn't work well
if [[ "$TERM" == "screen" ]]; then
        DISPLAY=""
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

local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*:(ssh|scp|sftp|rsync):*' hosts $knownhosts

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

for k in ${(k)key} ; do
    # $terminfo[] entries are weird in ncurses application mode...
    [[ ${key[$k]} == $'\eO'* ]] && key[$k]=${key[$k]/O/[}
done
unset k

[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
#[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" history-search-backward
#[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" history-search-forward
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

setprompt () {
    setopt prompt_subst

    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"


    ###
    # Decide if we need to set titlebar text.
    case $TERM in
	    xterm*|rxvt*)
	        PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
	        ;;
	    screen)
	        PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
	        ;;
	    *)
	        PR_TITLEBAR=''
	        ;;
    esac
    
    
    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]]; then
        PR_STITLE=$'%{\ekzsh %~\e\\%}'
    else
	    PR_STITLE=''
    fi
    
    
    ###
    # Finally, the prompt.

    PROMPT='$PR_STITLE${(e)PR_TITLEBAR}%(!.$PR_RED.$PR_GREEN)%n$PR_NO_COLOUR@$PR_MAGENTA%m$PR_NO_COLOUR:$PR_CYAN%~$PR_NO_COLOUR\

%(?.$PR_LIGHT_GREEN.$PR_LIGHT_RED)%?$PR_NO_COLOUR%# '
}

setprompt


### ALIASES ###

# FreeBSD's ls doesn't support --color :( :( :(
if `/bin/ls --color > /dev/null 2>&1`; then
        alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias :q='exit'

alias udiskie-umount='udiskie-umount -s'
alias udiskie='udiskie -s'


### LOCAL CONFIG ###
if [ -f ~/.zshrc-local ]; then
    source ~/.zshrc-local
fi
