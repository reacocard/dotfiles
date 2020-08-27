#!/bin/sh
# Script to toggle a dconf boolean, and optionally send a notification of the
# change.

notify_cmd_base="notify-send --app-name=dconf_toggle --icon=system-run --expire-time=1000 --hint=int:transient:1"
notify_title=""
notify_true="Enabled"
notify_false="Disabled"

while getopts 'n:t:f:' opt; do
	case "$opt" in
		n)	notify_title="$OPTARG";;
		t)	notify_true="$OPTARG";;
		f)	notify_false="$OPTARG";;
		[?])	print >&2 "Unexpected argument."
			exit 1
			;;
	esac
done
shift `expr $OPTIND - 1`

dconf_key="$1"


if [ `dconf read "$dconf_key"` = "true" ]; then
	value="false"
	notify_value="$notify_false"
else
	value="true"
	notify_value="$notify_true"
fi

dconf write "$dconf_key" "$value"
if [ -n "$notify_title" ]; then
	$notify_cmd_base "$notify_title: $notify_value"
fi
