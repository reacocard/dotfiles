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
		ca.desrt.dconf-editor \
		com.spotify.Client \
		org.glimpse_editor.Glimpse \
		org.gnome.Calculator \
		org.gnome.Cheese \
		org.gnome.dfeet \
		org.gnome.Evince \
		org.gnome.Extensions \
		org.gnome.NetworkDisplays \
		org.gnome.PowerStats \
		org.gnome.eog \
		org.gnome.seahorse.Application \
		org.mozilla.firefox \
		org.gnome.Logs

	flatpak override --user org.glimpse_editor.Glimpse \
			 --socket wayland 
	flatpak override --user org.mozilla.firefox \
		         --socket wayland \
			 --filesystem=~/downloads:rw \
			 --filesystem=~/media:ro \
			 --filesystem=~/syncthing/Media:ro
}


# personal machines only

machinetype_personal () {
	flatpak install --noninteractive flathub \
		com.bitwarden.desktop \
		com.calibre_ebook.calibre \
		com.discordapp.Discord \
		com.github.micahflee.torbrowser-launcher \
		com.github.unrud.djpdf \
		com.makemkv.MakeMKV \
		com.obsproject.Studio \
		com.slack.Slack \
		com.valvesoftware.Steam \
		com.visualstudio.code \
		fr.handbrake.ghb \
		io.github.quodlibet.ExFalso \
		org.blender.Blender \
		org.bunkus.mkvtoolnix-gui \
		org.gnome.Boxes \
		org.gnome.Contacts \
		org.gnome.Evolution \
		org.gnome.Totem \
		org.kde.krita \
		org.libretro.RetroArch \
		org.signal.Signal \
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
	flatpak override --user com.slack.Slack \
		         --socket wayland
	flatpak override --user org.videolan.VLC \
		         --socket wayland
}

# wayland only

sessiontype_wayland () {
	flatpak override --user org.mozilla.firefox \
			 --env=MOZ_USE_XINPUT2=1 \
			 --env=MOZ_ENABLE_WAYLAND=1
	flatpak override --user org.glimpse_editor.Glimpse \
			 --env=GDK_BACKEND=wayland
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
