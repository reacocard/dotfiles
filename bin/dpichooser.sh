#!/bin/zsh

# Attempts to detect a sensible DPI.
# Results are rounded to multiples of $mult to try to keep fonts sharp.
# On laptops, uses a scaling factor to increase 'effective' screen space.

set -o errexit
set -o nounset
set -o pipefail

mm_per_i="24.5"
factor=1.29
mult=8

xr_primary=`xrandr -q | grep ' connected primary '`
measures=`echo "$xr_primary" | sed -E 's/.* ([0-9]+)x([0-9]+)\+[0-9]+\+[0-9]+ .* ([0-9]+)mm x ([0-9]+)mm/\1 \2 \3 \4/'`

if [[ $xr_primary == eDP* ]]; then
    echo "$measures" | awk '{ h=$1/($3/'$mm_per_i'); v=$2/($4/'$mm_per_i'); if (h>v) { dpi=h } else { dpi=v }; hidpi=int(dpi/('$factor'*'$mult'))*'$mult'; dpi=int(dpi/'$mult')*'$mult'; if (hidpi > 96) { print hidpi } else { print dpi } }'
else
    echo "$measures" | awk '{ h=$1/($3/'$mm_per_i'); v=$2/($4/'$mm_per_i'); if (h>v) { dpi=h } else { dpi=v }; dpi=int(dpi/'$mult')*'$mult'; print dpi }'
fi
