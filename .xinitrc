#!/bin/zsh

# This is just a simple script to select among sessions.
# Actual starting of toolbars, WMs, apps, etc. should be kept in a script
# launched by this file, not in the file directly. For items that will
# be launched in all sessions a script may be placed in ~/.autostart,
# though sessions must opt-in to it using that by adding 
# "run-parts ~/.autostart &" to their script.

xset -b # Disable the nasty beeping

xrdb $HOME/.Xdefaults

$HOME/bin/dpichooser.sh > $HOME/.cache/reacocard-dpi
xrdb -merge <(echo "Xft*dpi: $(cat $HOME/.cache/reacocard-dpi)")

source $HOME/.zprofile

exec ~/.xmonad/startup.sh
