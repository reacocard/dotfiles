#!/bin/bash
# Turns flatpak .desktop files into scripts that can go in $PATH.
# This is helpful if you use launchers like dmenu that don't understand
# the XDG .desktop format.

set -o nounset
set -o pipefail

DEBUG=1

if [ -z "$1" ]; then
	echo 'Must specify target dir as first argument.' >&2
	exit 1
fi

if [ -z "$XDG_DATA_DIRS" ]; then
	echo '$XDG_DATA_DIRS is not set.' >&2
	exit 1
fi

for data_dir in ${XDG_DATA_DIRS//:/ }; do
	if [ ! -d "$data_dir" ] || [ ! -d "$data_dir/applications" ]; then
		continue
	fi
	if [ $DEBUG ]; then echo -e "=== data dir: $data_dir ===\n"; fi
	for desktop in ${data_dir}applications/*.desktop; do
		execline=`< $desktop grep --max-count=1 '^Exec='`
		if echo "$execline" | grep -v -q 'bin/flatpak'; then
			continue
		fi
		if [ $DEBUG ]; then echo "execline: $execline"; fi

		command_name=`echo $execline | egrep --only-matching '\w[A-Za-z0-9_]+(\.[A-Za-z0-9_]+)+\w'`
		if [ $DEBUG ]; then echo "command name: $command_name"; fi
		command_exec=`echo $execline | cut -c 6- | sed -E 's/ (@@|%)[^ ]*//g'`
		if [ $DEBUG ]; then echo "command exec: $command_exec"; fi
		target_filename="$1/$command_name"
		if [ $DEBUG ]; then echo "target filename: $target_filename"; fi
		echo -e "#!/bin/sh\nexec $command_exec \"\$@\"" > "$target_filename"
		chmod +x "$target_filename"
		if [ $DEBUG ]; then echo; fi
	done
done
exit 0

# TODO: remove items that no longer exist
