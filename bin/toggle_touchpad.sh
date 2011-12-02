#!/bin/sh

synclient TouchpadOff=$(expr 1 - $(synclient -l | grep TouchpadOff | cut -b 31))
