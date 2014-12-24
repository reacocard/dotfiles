#!/bin/zsh

# Disable X default screensaver
xset s off

# 31 minute dpms blank - lock is at 30.25 minutes.
xset dpms 0 0 1860

exec xautolock -locker "xlock -lockdelay 15" -nowlocker "xlock"
