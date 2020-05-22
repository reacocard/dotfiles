#!/bin/bash
# Args: statefile time_between_successes time_between_fails command command-args


set -o errexit
set -o nounset
set -o pipefail

statefile="$1"
time_between_successes="$2"
time_between_fails="$3"
command_to_run="$4"
shift 4


if [ ! -e "$statefile" ]; then
	echo -e "0\n0" > "$statefile"
fi

last_success="$(head -n1 $statefile)"
last_fail="$(tail -n1 $statefile)"
current_time="$(date +%s)"

if [ $last_fail -gt $last_success ]; then
	if [ $time_between_fails -gt $(expr $current_time - $last_fail) ]; then
		echo "Too close to last failure, skipping."
		exit 0
	fi
else
	if [ $time_between_successes -gt $(expr $current_time - $last_success) ]; then
		echo "Too close to last success, skipping."
		exit 0
	fi
fi

if $command_to_run "$@"; then
	echo -e "$(date +%s)\n$last_fail" > $statefile
else
	echo -e "$last_success\n$(date +%s)" > $statefile
fi

