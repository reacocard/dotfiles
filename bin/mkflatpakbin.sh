#!/bin/bash
# Turns flatpak .desktop files into scripts that can go in $PATH.
# This is helpful if you use launchers like dmenu that don't understand
# the XDG .desktop format.

set -o nounset
set -o pipefail

if [ -z "$1" ]; then
	echo 'Must specify target dir as first argument.' >&2
	exit 1
fi

if [ -z "$XDG_DATA_DIRS" ]; then
	echo '$XDG_DATA_DIRS is not set.' >&2
	exit 1
fi

for data_dir in ${XDG_DATA_DIRS//:/ }; do
	if [ ! -d $data_dir ] || [ ! -d $data_dir/applications ]; then
		continue
	fi
	for desktop in ${data_dir}applications/*.desktop; do
		execline=`< $desktop grep --max-count=1 '^Exec='`
		if echo "$execline" | grep -v -q 'bin/flatpak'; then
			continue
		fi

		command_name=`echo $execline | egrep --only-matching '[A-Za-z0-9]+(\.[A-Za-z0-9]+)+'`
		command_exec=`echo $execline | cut -c 6- | sed -E 's/ (@@|%)[^ ]*//g'`
		target_filename="$1/$command_name"
		echo -e "#!/bin/sh\nexec $command_exec \"\$@\"" > $target_filename
		chmod +x $target_filename
	done
done
exit 0

# TODO: remove items that no longer exist
