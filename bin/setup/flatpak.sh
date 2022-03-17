#!/bin/zsh
# set up flatpak apps how i like them

set -o errexit
set -o pipefail
set -o nounset


setup () {
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

always () {
	flatpak install --noninteractive flathub \
		org.gimp.GIMP \
		org.gnome.NetworkDisplays \
		org.mozilla.firefox

	flatpak override --user org.gimp.GIMP \
			 --socket wayland 
	flatpak override --user org.mozilla.firefox \
			 --env MESA_GLSL_CACHE_DISABLE=1
}


# personal machines only

machinetype_personal () {
	flatpak install --noninteractive flathub \
		com.bitwarden.desktop \
		com.calibre_ebook.calibre \
		com.discordapp.Discord \
		com.makemkv.MakeMKV \
		com.slack.Slack \
		com.valvesoftware.Steam \
		fr.handbrake.ghb \
		io.github.quodlibet.ExFalso \
		org.blender.Blender \
		org.telegram.desktop \
		org.videolan.VLC \
		org.videolan.VLC.Plugin.bdj \
		org.videolan.VLC.Plugin.makemkv

	flatpak override --user com.valvesoftware.Steam \
			 --filesystem=~/media:ro \
		         --filesystem=~/syncthing/Media:ro \
		         --filesystem=~/syncthing/Archives/Music:ro
	flatpak override --user com.discordapp.Discord \
		         --socket wayland
	flatpak override --user com.makemkv.MakeMKV \
		         --socket wayland
	flatpak override --user com.slack.Slack \
		         --socket wayland
	flatpak override --user org.videolan.VLC \
		         --socket wayland
}

# wayland only

sessiontype_wayland () {
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

if [ x"$XDG_SESSION_TYPE" = x"wayland" ]; then
	sessiontype_wayland
fi
