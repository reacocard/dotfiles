#!/bin/sh

xautolock -locknow

systemctl suspend || upower_suspend.sh

