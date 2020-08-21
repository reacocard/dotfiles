#!/bin/sh
# Make a wrapper script for running an app via a .desktop
# This is especially useful for flatpak apps that you want to be accessible on
# the command line.
#
# Usage: mklaunch.sh desktop_file_name wrapper_file_name

echo '#!/bin/sh\nexec gtk-launch '"$1"' "$@"' > $2
chmod +x $2
