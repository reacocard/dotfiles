#!/bin/zsh

FILE=~/.local/share/icc/active.icc
if [ -x $FILE ]; then
	xcalib $FILE
fi
