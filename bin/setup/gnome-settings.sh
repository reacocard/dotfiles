#!/bin/bash
# Updates settings in dconf to match my preferences.

set -o errexit
set -o nounset
set -o pipefail
set -o verbose

### DESKTOP ENV ###

dconf write /org/gnome/desktop/wm/preferences/audible-bell false

dconf write /org/gnome/desktop/wm/preferences/button-layout "':'"
dconf write /org/gnome/desktop/wm/preferences/resize-with-right-button true

dconf write /org/gnome/desktop/interface/document-font-name "'Andika 13'"
dconf write /org/gnome/desktop/interface/font-name "'Andika 13'"
dconf write /org/gnome/desktop/interface/monospace-font-name "'DejaVu Sans Mono 13'"
dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'Andika Bold 13'"
dconf write /org/gnome/settings-daemon/plugins/xsettings/antialiasing "'grayscale'"
dconf write /org/gnome/settings-daemon/plugins/xsettings/hinting "'slight'"


dconf write /org/gnome/desktop/interface/clock-show-weekday true
dconf write /org/gnome/desktop/interface/locate-pointer true
dconf write /org/gnome/desktop/interface/show-battery-percentage true

dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"
dconf write /org/gnome/desktop/interface/gtk-enable-primary-paste false

# Enable screen sharing.
mutter_features=`dconf read /org/gnome/mutter/experimental-features`
if echo "$mutter_features" | grep -q "'screen-cast'"; then
	true
else
	mutter_features=`echo "$mutter_features" | sed "s/]/, 'screen-cast']/"`
fi
if echo "$mutter_features" | grep -q "'remote-desktop'"; then
	true
else
	mutter_features=`echo "$mutter_features" | sed "s/]/, 'remote-desktop']/"`
fi
dconf write /org/gnome/mutter/experimental-features "$mutter_features"

dconf write /org/gnome/mutter/wayland/xwayland-allow-grabs true
dconf write /org/gnome/mutter/wayland/xwayland-grab-access-rules "['*']"

dconf write /org/gnome/desktop/session/idle-delay 600
dconf write /org/gnome/desktop/screensaver/lock-delay 30 || true
# TODO: put bg image in git so we can set it automatically
# This needs to happen in both screensaver and background schemas

dconf write /org/gnome/desktop/peripherals/mouse/speed 0.2

dconf write /org/gnome/desktop/media-handling/autorun-never true
dconf write /org/gnome/desktop/sound/allow-volume-above-100-percent true

# capslock is compose key
xkb_opts="'compose:caps'"
# prtscr is another super/windows key
# on recent thinkpads prtscr is in the right super/windows spot
xkb_opts="$xkb_opts, 'altwin:prtsc_rwin'"
dconf write /org/gnome/desktop/input-sources/xkb-options "[$xkb_opts]"


dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled true
dconf write /org/gnome/settings-daemon/plugins/power/ambient-enabled false
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout 1800


dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/mutter/workspaces-only-on-primary false
NR_WORKSPACES=12
dconf write /org/gnome/desktop/wm/preferences/num-workspaces $NR_WORKSPACES
dconf write /org/gnome/shell/app-switcher/current-workspace-only true

# TODO: figure out how to handle gnome-shell extensions


dconf write /org/gtk/settings/file-chooser/sort-directories-first true

dconf write /org/gnome/shell/favorite-apps "['org.mozilla.firefox.desktop', 'google-chrome.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"

### KEYBINDINGS ###
dconf write /org/gnome/settings-daemon/plugins/media-keys/help "'[]'"
for i in `seq 1 $NR_WORKSPACES`; do
	dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-${i} "['<Super>F${i}']";
	dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-${i} "['<Shift><Super>F${i}']";
done
dconf write /org/gnome/desktop/wm/keybindings/begin-move "'[]'"
dconf write /org/gnome/desktop/wm/keybindings/begin-resize "'[]'"
gsettings set 'org.gnome.desktop.wm.keybindings' switch-applications "[]"
gsettings set 'org.gnome.desktop.wm.keybindings' switch-applications-backward "[]"
gsettings set 'org.gnome.desktop.wm.keybindings' switch-windows "['<Alt>Tab']"
gsettings set 'org.gnome.desktop.wm.keybindings' switch-windows-backward "['<Shift><Alt>Tab']"

CUSTOM_BINDS_BASE='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings'

dconf write "$CUSTOM_BINDS_BASE/custom0/binding" "'<Shift><Super>l'"
dconf write "$CUSTOM_BINDS_BASE/custom0/command" "'systemctl suspend'"
dconf write "$CUSTOM_BINDS_BASE/custom0/name" "'Sleep'"

dconf write "$CUSTOM_BINDS_BASE/custom1/binding" "'<Super>apostrophe'"
dconf write "$CUSTOM_BINDS_BASE/custom1/command" "'firefox'"
dconf write "$CUSTOM_BINDS_BASE/custom1/name" "'Launch Firefox'"

dconf write "$CUSTOM_BINDS_BASE/custom2/binding" "'<Shift><Super>quotedbl'"
dconf write "$CUSTOM_BINDS_BASE/custom2/command" "'firefox --private-window'"
dconf write "$CUSTOM_BINDS_BASE/custom2/name" "'Launch Firefox Private'"

dconf write "$CUSTOM_BINDS_BASE/custom3/binding" "'<Super>semicolon'"
dconf write "$CUSTOM_BINDS_BASE/custom3/command" "'google-chrome-stable'"
dconf write "$CUSTOM_BINDS_BASE/custom3/name" "'Launch Chrome'"

dconf write "$CUSTOM_BINDS_BASE/custom4/binding" "'<Shift><Super>colon'"
dconf write "$CUSTOM_BINDS_BASE/custom4/command" "'google-chrome-stable --incognito'"
dconf write "$CUSTOM_BINDS_BASE/custom4/name" "'Launch Chrome Private'"

dconf write "$CUSTOM_BINDS_BASE/custom5/binding" "'<Super>Return'"
dconf write "$CUSTOM_BINDS_BASE/custom5/command" "'gnome-terminal'"
dconf write "$CUSTOM_BINDS_BASE/custom5/name" "'Launch Terminal'"

dconf write "$CUSTOM_BINDS_BASE" "['$CUSTOM_BINDS_BASE/custom0/', '$CUSTOM_BINDS_BASE/custom1/', '$CUSTOM_BINDS_BASE/custom2/', '$CUSTOM_BINDS_BASE/custom3/', '$CUSTOM_BINDS_BASE/custom4/', '$CUSTOM_BINDS_BASE/custom5/']"

### EXTENSIONS ###

enabled_extensions=`dconf read /org/gnome/shell/enabled-extensions`
for ext in 'sound-output-device-chooser@kgshank.net' 'launch-new-instance@gnome-shell-extensions.gcampax.github.com' 'multi-monitors-add-on@spin83' 'user-theme@gnome-shell-extensions.gcampax.github.com' 'just-perfection-desktop@just-perfection' 'miniCal3@mtharpe'; do
	if echo "$enabled_extensions" | grep -q "'$ext'"; then
		true
	else
		enabled_extensions=`echo "$enabled_extensions" | sed "s/]/, '$ext']/"`
	fi
done

dconf write /org/gnome/shell/enabled-extensions "$enabled_extensions"

dconf write /org/gnome/shell/extensions/just-perfection/dash false

### FILE BROWSER ###

dconf write /org/gnome/nautilus/list-view/default-column-order "['starred', 'name', 'date_modified', 'size', 'detailed_type', 'type', 'owner', 'group', 'permissions', 'where', 'date_modified_with_time', 'date_accessed', 'recency']"
dconf write /org/gnome/nautilus/list-view/default-visible-columns "['starred', 'name', 'date_modified', 'size', 'detailed_type']"
dconf write /org/gnome/nautilus/preferences/default-folder-viewer "'list-view'"
dconf write /org/gnome/nautilus/preferences/show-create-link true
dconf write /org/gnome/nautilus/preferences/show-delete-permanently true
dconf write /org/gnome/nautilus/preferences/thumbnail-limit 50


### TERMINAL ###
dconf write /org/gnome/terminal/legacy/theme-variant "'dark'"
TERM_PROFILE=`gsettings get 'org.gnome.Terminal.ProfilesList' default | cut -d\' -f2`

dconf write /org/gnome/terminal/legacy/profiles:/:$TERM_PROFILE/audible-bell false
dconf write /org/gnome/terminal/legacy/profiles:/:$TERM_PROFILE/bold-is-bright true
dconf write /org/gnome/terminal/legacy/profiles:/:$TERM_PROFILE/default-size-columns 120
dconf write /org/gnome/terminal/legacy/profiles:/:$TERM_PROFILE/default-size-rows 36
