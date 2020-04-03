#!/bin/sh
# For some reason when pulse starts at the beginning of the session it doesn't
# always detect my inputs and outputs correctly. Restarting it always fixes
# this so, just always restart it shortly after login.
# TODO: make this smarter, i.e. only restart if there are missing devices.a
if pactl list short sinks | egrep -q -v -i '(monitor|dummy)' && \
   pactl list short sources | egrep -q -v -i '(monitor|dummy)'; then
   exit 0
else
   systemctl --user restart pulseaudio
fi
