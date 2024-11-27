#!/bin/zsh
# install many packages i like


pkg_core=""
# basics
pkg_core="$pkg_core curl file info nano openssh-client plocate rsync screen tmux wget wireless-regdb xdg-utils zsh"
# compression
pkg_core="$pkg_core arj atool lbzip2 lzip lzop p7zip-full rar unrar unzip xz-utils zstd"
# sysadmin/debug tools
pkg_core="$pkg_core apt-file apt-listchanges attr bind9-dnsutils ethtool hdparm htop iftop iotop-c iperf3 lshw lsof lsscsi net-tools nmap nvme-cli powercap-utils powertop sdparm sg3-utils sg3-utils-udev strace tcpdump traceroute usbtop"
# useful cli tools
pkg_core="$pkg_core ack bsdextrautils curl faketime git git-lfs imagemagick ipython3 jq pv rename reptyr ripgrep sqlite3 sshfs tree virtualenv whois"

pkg_personal=""
# compression
pkg_personal="$pkg_personal 7zip cpio"
# podman
pkg_personal="$pkg_personal buildah podman slirp4netns"
# build/dev tools
pkg_personal="$pkg_personal build-essential cmake elfutils meson"
# filesystem/blockdev tools
pkg_personal="$pkg_personal btrfs-compsize btrfs-progs cifs-utils cryptsetup e2fsprogs gocryptfs lvm2 mame-tools mdadm mtools nfs-common smartmontools smbclient squashfs-tools squashfs-tools-ng udfclient udftools xorriso"
# sysadmin/debug tools
pkg_personal="$pkg_personal f3 fio lm-sensors memtest86+ turbostat"
# backup and recovery
pkg_personal="$pkg_personal borgbackup borgmatic btrbk cdparanoia dvdisaster gddrescue par2 xdelta3"
# multimedia
pkg_personal="$pkg_personal atomicparsley fdkaac flac ffmpeg lame mediainfo mp3gain mkvtoolnix optipng opus-tools replaygain tvnamer vorbisgain vorbis-tools youtube-dl"

pkg_personal="$pkg_personal avahi-daemon bolt certbot debdelta debsums distrobox duperemove firmware-atheros firmware-intel-sound firmware-iwlwifi firmware-linux firmware-misc-nonfree firmware-realtek firmware-sof-signed fwupd hugo internetarchive jdupes magic-wormhole miniupnpc natpmpc netcat-traditional openssh-server pipx postgresql-client python3-certbot-dns-rfc2136 python3-sh rclone regionset speedtest-cli sshuttle syncthing telnet thunderbolt-tools tpm2-tools turbostat unattended-upgrades v4l-utils watchdog wireguard-tools wsdd-server ykcs11 yubico-piv-tool yubikey-manager"

pkg_gui="avahi-discover cups fido2-tools flatpak fonts-ancient-scripts fonts-roboto fonts-cantarell fonts-dejavu fonts-liberation fonts-noto fonts-mph-2b-damase fonts-roboto fonts-sil-andika fonts-symbola fonts-terminus fonts-ubuntu fonts-ubuntu-console gnome-backgrounds gnome-bluetooth gnome-color-manager gnome-disk-utility gnome-keyring gnome-remote-desktop gnome-screenshot gnome-shell gnome-shell-extensions gnome-terminal gnome-themes-extra gnome-tweaks gstreamer1.0-pipewire gstreamer1.0-plugins-base gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-good gstreamer1.0-libcamera gstreamer1.0-pulseaudio gstreamer1.0-tools gvfs-fuse heif-gdk-pixbuf heif-thumbnailer ipp-usb libavif-gdk-pixbuf libcamera-ipa libcamera-tools libcamera-v4l2 librsvg2-common libspa-0.2-bluetooth libspa-0.2-jack libspa-0.2-libcamera libspa-0.2-modules nautilus nautilus-extension-burner nautilus-extension-gnome-terminal network-manager-config-connectivity-debian network-manager-gnome ooo-thumbnailer pavucontrol pipewire pipewire-alsa pipewire-jack pipewire-pulse pipewire-v4l2 pulseaudio-utils sane-airscan system-config-printer ttf-bitstream-vera vim-gtk3 webp-pixbuf-loader wireplumber xarchiver xdg-desktop-portal-gnome xwayland"

pkg_gui_personal="android-sdk-platform-tools-common argyll cardpeek deluge-gtk firejail firewall-config gnupg-pkcs11-scd gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-bad-apps gstreamer1.0-plugins-ugly krita krita-gmic libdvd-pkg libpam-fprintd mcomix mediainfo-gui mpv obs-plugins obs-studio picard plymouth plymouth-themes remmina replaygain scdaemon seahorse seahorse-nautilus spice-client-glib-usb-acl-helper steam-devices torbrowser-launcher ttf-mscorefonts-installer v4l2loopback-dkms v4l2loopback-utils virt-manager wireshark-gtk"

pkg_mesa="clinfo drm-info gstreamer1.0-vaapi mesa-utils mesa-utils-extra mesa-va-drivers mesa-vulkan-drivers vainfo vulkan-tools"

pkg_gfx_intel="i965-va-driver-shaders intel-gpu-tools intel-media-va-driver intel-opencl-icd $pkg_mesa"

pkg_gfx_amd="firmware-amd-graphics mesa-opencl-icd $pkg_mesa"

pkg_cpu_intel="intel-microcode"

pkg_cpu_amd="amd64-microcode"

if ! < /proc/cpuinfo | grep -q 'vendor_id.*AuthenticAMD'; then
	pkg_cpu_amd=""
else
	echo "AMD CPU detected"
fi

if ! < /proc/cpuinfo | grep -q 'vendor_id.*GenuineIntel'; then
	pkg_cpu_intel=""
else
	echo "Intel CPU detected"
fi

if ! lspci | grep -q 'VGA.*Advanced Micro Devices'; then
	pkg_gfx_amd=""
else
	echo "AMD GPU detected"
fi

if ! lspci | grep -q 'VGA.*Intel.*Graphics'; then
	pkg_gfx_intel=""
else
	echo "Intel GPU detected"
fi


while true; do
	echo -n "Is this a personal machine? (y/n): "
	case `read -e` in
		[Yy]* ) break;;
		[Nn]* ) pkg_personal=""; pkg_gui_personal=""; break;;
		* ) echo "Please answer y or n.";;
	esac
done

while true; do
	echo -n "Is this a GUI machine? (y/n): "
	case `read -e` in
		[Yy]* ) break;;
		[Nn]* ) pkg_gui=""; pkg_gui_personal=""; break;;
		* ) echo "Please answer y or n.";;
	esac
done


sudo apt install --no-install-recommends ${=pkg_core} ${=pkg_core_personal} ${=pkg_gui} ${=pkg_gui_personal} ${=pkg_cpu_amd} ${=pkg_cpu_intel} ${=pkg_gfx_amd} ${=pkg_gfx_intel}
