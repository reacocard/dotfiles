#!/bin/sh

xset s activate
#xautolock -locknow

systemctl suspend || upower_suspend.sh

