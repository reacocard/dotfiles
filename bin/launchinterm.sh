#!/bin/bash

APPS=('htop' 'top')

TERMEXEC="urxvt -e "

for i in ${APPS[@]}; do 
    if [[ $i == $1 ]]; then
        exec $TERMEXEC "$*"
    fi
done

exec "$*"
