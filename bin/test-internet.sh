#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail


if [ `nmcli networking connectivity` != 'full' ]; then
	>&2 echo "No internet access."
	exit 1
fi

for uuid in `nmcli --get-values uuid connection show --active`; do
	if nmcli connection show $uuid | grep 'connection.metered:' | grep -q yes; then
		echo "Connection $uuid is metered."
		exit 2
	fi
done
