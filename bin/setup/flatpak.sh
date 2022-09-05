#!/bin/zsh
# set up flatpak apps how i like them

set -o errexit
set -o pipefail
set -o nounset

fo () {
	flatpak override --user --reset $1
	flatpak override --user "$@"
}

setup () {
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

always () {
	flatpak install --noninteractive flathub \
		org.gimp.GIMP \
		org.gnome.NetworkDisplays \
		org.mozilla.firefox

	fo org.gimp.GIMP --socket wayland
	fo org.mozilla.firefox --env MOZ_DISABLE_RDD_SANDBOX=1  # for VA-API
}


# personal machines only

machinetype_personal () {
	flatpak install --noninteractive flathub \
		com.bitwarden.desktop \
		com.discordapp.Discord \
		com.makemkv.MakeMKV \
		com.slack.Slack \
		com.valvesoftware.Steam \
		com.valvesoftware.Steam.Utility.gamescope \
		fr.handbrake.ghb \
		io.github.quodlibet.ExFalso \
		org.telegram.desktop \
		org.videolan.VLC \
		org.videolan.VLC.Plugin.bdj \
		org.videolan.VLC.Plugin.makemkv \
		com.github.iwalton3.jellyfin-media-player

	fo com.valvesoftware.Steam \
		--filesystem=home/media:ro \
		--filesystem=home/syncthing/Media:ro \
		--filesystem=home/syncthing/Archives/Music:ro \
		--filesystem=home/media/pictures/syncthing/Screenshots/Steam \
		--filesystem=home/syncthing/Media/Pictures/Screenshots/Steam
	fo com.makemkv.MakeMKV --socket wayland
	fo org.videolan.VLC --socket wayland
	fo com.github.iwalton3.jellyfin-media-player \
		--socket wayland \
		--env QT_QPA_PLATFORM="wayland;xcb"
}

setup 
always

while true; do
	echo -n "Is this a personal machine? (y/n): "
	case `read -e` in
		[Yy]* ) machinetype_personal; break;;
		[Nn]* ) break;;
		* ) echo "Please answer y or n.";;
	esac
done
