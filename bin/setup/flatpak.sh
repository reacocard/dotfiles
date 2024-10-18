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
		org.mozilla.firefox \
		org.gtk.Gtk3theme.adw-gtk3 \
		org.gtk.Gtk3theme.adw-gtk3-dark \
		org.gtk.Gtk3theme.Adwaita-dark \
		org.kde.KStyle.Adwaita \
		org.kde.PlatformTheme.QGnomePlatform \
		org.kde.WaylandDecoration.QAdwaitaDecorations \
		org.kde.WaylandDecoration.QGnomePlatform-decoration \
		org.freedesktop.Platform.openh264

	flatpak override --user --filesystem xdg-config/gtk-2.0:ro --filesystem xdg-config/gtk-3.0:ro

	fo org.gimp.GIMP --socket wayland
	fo org.mozilla.firefox --env MOZ_DISABLE_RDD_SANDBOX=1  # for VA-API
}


# personal machines only

machinetype_personal () {
	flatpak install --noninteractive flathub \
		com.bitwarden.desktop \
		com.discordapp.Discord \
		com.github.iwalton3.jellyfin-media-player \
		com.github.tchx84.Flatseal \
		com.makemkv.MakeMKV \
		com.slack.Slack \
		com.valvesoftware.Steam \
		com.valvesoftware.Steam.Utility.gamescope \
		fr.handbrake.ghb \
		io.github.quodlibet.ExFalso \
		org.inkscape.Inkscape \
		org.kde.krita \
		org.kde.krita.Codecs \
		org.localsend.localsend_app \
		org.pipewire.Helvum \
		org.signal.Signal \
		org.telegram.desktop \
		org.videolan.VLC \
		org.videolan.VLC.Plugin.bdj \
		org.videolan.VLC.Plugin.fdkaac \
		org.videolan.VLC.Plugin.makemkv \
		org.freedesktop.Platform.ffmpeg-full \

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
