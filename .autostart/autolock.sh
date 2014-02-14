#!/bin/sh

# Disable X default screensaver
xset s off

# 11 minute dpms blank - lock is at 10.25 minutes.
xset dpms 0 0 660

exec xautolock -locker "xlock -lockdelay 15" -nowlocker "xlock"
