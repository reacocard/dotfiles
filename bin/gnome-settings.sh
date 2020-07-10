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


dconf write /org/gnome/desktop/interface/clock-show-weekday true
dconf write /org/gnome/desktop/interface/locate-pointer true
dconf write /org/gnome/desktop/interface/show-battery-percentage true

dconf write /org/gnome/desktop/interface/gtk-enable-primary-paste false

dconf write /org/gnome/desktop/interface/text-scaling-factor 1.1

# Enable fractional scaling and screen sharing.
dconf write /org/gnome/mutter/experimental-features "['scale-monitor-framebuffer', 'screen-cast', 'remote-desktop']"



dconf write /org/gnome/desktop/session/idle-delay 600
dconf write /org/gnome/desktop/screensaver/lock-delay 30
# TODO: put bg image in git so we can set it automatically
# This needs to happen in both screensaver and background schemas

dconf write /org/gnome/desktop/peripherals/mouse/speed 0.2

dconf write /org/gnome/desktop/media-handling/autorun-never true

dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:super']"


dconf write /org/gnome/settings-daemon/plugins/color/night-light-enabled true
dconf write /org/gnome/settings-daemon/plugins/power/ambient-enabled false
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type "'nothing'"
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout 1800


dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/mutter/workspaces-only-on-primary true
NR_WORKSPACES=12
dconf write /org/gnome/desktop/wm/preferences/num-workspaces $NR_WORKSPACES
dconf write /org/gnome/shell/app-switcher/current-workspace-only true

# TODO: figure out how to handle gnome-shell extensions


dconf write /org/gtk/settings/file-chooser/sort-directories-first true


### KEYBINDINGS ###
for i in {1..$NR_WORKSPACES}; do
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
