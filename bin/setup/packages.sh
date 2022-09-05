#!/bin/zsh
# install many packages i like


pkg_core="ack apt-file apt-listchanges arj atool attr avahi-daemon bind9-dnsutils bolt bsdextrautils cpulimit curl faketime file git git-lfs htop iftop imagemagick info iotop-c iperf3 ipython3 jq lbzip2 lshw lsof lzip lzop mlocate nano net-tools nmap openssh-client p7zip-full powercap-utils powertop pv rar rename reptyr ripgrep rsync screen sshfs strace tcpdump tmux traceroute unrar unzip usbtop virtualenv wget whois wireless-regdb xdg-utils xz-utils zip zsh zstd"

pkg_personal="atomicparsley borgbackup borgmatic btrbk build-essential buildah certbot cdparanoia cifs-utils cmake cpio cryptsetup debdelta docker-compose duperemove f3 fio firmware-atheros firmware-intel-sound firmware-iwlwifi firmware-linux firmware-misc-nonfree firmware-realtek firmware-sof-signed ffmpeg fwupd gddrescue gocryptfs hugo internetarchive jdupes lm-sensors lvm2 magic-wormhole mame-tools mdadm mediainfo meson miniupnpc mtools plocate mkvtoolnix netcat-traditional nfs-common openssh-server optipng par2 podman pngcrush python3-certbot-dns-rfc2136 slirp4netns smartmontools smbclient speedtest-cli squashfs-tools squashfs-tools-ng sshuttle syncthing telnet thunderbolt-tools tpm2-tools tvnamer unattended-upgrades udfclient udftools v4l-utils watchdog wireguard-tools xdelta3 xorriso youtube-dl ykcs11 yubico-piv-tool yubikey-manager"

pkg_gui="avahi-discover cups flatpak fonts-ancient-scripts fonts-cantarell fonts-liberation fonts-mph-2b-damase fonts-sil-andika fonts-symbola fonts-terminus fonts-ubuntu fonts-ubuntu-console gnome-backgrounds gnome-bluetooth gnome-color-manager gnome-disk-utility gnome-keyring gnome-remote-desktop gnome-screenshot gnome-shell gnome-shell-extensions gnome-terminal gnome-themes-extra gnome-tweaks gstreamer1.0-pipewire gstreamer1.0-plugins-base gstreamer1.0-plugins-base-apps gstreamer1.0-plugins-good gstreamer1.0-pulseaudio gstreamer1.0-tools gvfs-fuse heif-thumbnailer ipp-usb libspa-0.2-bluetooth nautilus nautilus-extension-burner nautilus-extension-gnome-terminal network-manager-config-connectivity-debian network-manager-gnome ooo-thumbnailer pavucontrol pipewire pipewire-pulse pulseaudio-module-bluetooth pulseaudio-utils sane-airscan system-config-printer ttf-bitstream-vera viewnior vim-gtk3 wireplumber xarchiver xdg-desktop-portal-gnome xwayland"

pkg_gui_personal="android-sdk-platform-tools-common argyll cardpeek deluge-gtk firejail firewall-config gnupg-pkcs11-scd gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-bad-apps gstreamer1.0-plugins-ugly krita krita-gmic libdvd-pkg libpam-fprintd mcomix mediainfo-gui mp3gain mpv obs-plugins obs-studio picard plymouth plymouth-themes remmina replaygain scdaemon seahorse seahorse-nautilus spice-client-glib-usb-acl-helper steam-devices torbrowser-launcher v4l2loopback-dkms v4l2loopback-utils virt-manager vorbisgain wireshark-gtk"

pkg_mesa="clinfo drm-info gstreamer1.0-vaapi mesa-utils mesa-utils-extra mesa-va-drivers mesa-vulkan-drivers pocl-opencl-icd vainfo vulkan-tools"

pkg_gfx_intel="beignet-opencl-icd i965-va-driver-shaders intel-gpu-tools intel-media-va-driver $pkg_mesa"

pkg_gfx_amd="firmware-amd-graphics mesa-opencl-icd $pkg_mesa"

pkg_cpu_intel="intel-microcode"

pkg_cpu_amd="amd64-microcode"

# extra repos
#   google-chrome-stable
#   keybase

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
