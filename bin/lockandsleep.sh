#!/bin/sh

xset s activate
xset dpms force off
#xautolock -locknow

systemctl suspend || upower_suspend.sh

