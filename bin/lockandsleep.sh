#!/bin/sh

sudo -n -b /usr/sbin/pm-suspend || exit 1
exec xlock
