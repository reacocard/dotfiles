#!/bin/zsh
# install many packages i like


# AUR packages
# - usbtop
# - perl-file-rename
# - udfclient
# - f3
# - dvdisaster
# - jdupes
# - regionset
# - cardpeek
# - steam-devices-git


pkg_core=""
# basics
pkg_core="$pkg_core curl file texinfo nano openssh plocate rsync screen tmux wget wireless-regdb xdg-utils zsh"
# compression
pkg_core="$pkg_core arj atool lbzip2 lzip lzop unrar unzip xz zstd"
# sysadmin/debug tools
pkg_core="$pkg_core attr bind ethtool hdparm htop iftop iotop-c iperf3 lshw lsof lsscsi net-tools nmap nvme-cli powertop sdparm sg3_utils strace tcpdump traceroute usbutils"
# useful cli tools
pkg_core="$pkg_core libfaketime git git-lfs imagemagick ipython jq pv reptyr ripgrep sqlite sshfs tree python-virtualenv whois"

pkg_personal=""
# compression
pkg_personal="$pkg_personal 7zip cpio"
# podman
pkg_personal="$pkg_personal buildah podman slirp4netns"
# build/dev tools
pkg_personal="$pkg_personal base-devel cmake elfutils meson"
# filesystem/blockdev tools
pkg_personal="$pkg_personal compsize btrfs-progs cifs-utils cryptsetup e2fsprogs gocryptfs lvm2 mame-tools mdadm mtools nfs-utils smartmontools smbclient squashfs-tools udftools libisoburn"
# sysadmin/debug tools
pkg_personal="$pkg_personal fio lm_sensors memtest86+-efi turbostat wireshark-cli"
# backup and recovery
pkg_personal="$pkg_personal borg borgmatic btrbk cdparanoia ddrescue par2cmdline xdelta3"
# multimedia
pkg_personal="$pkg_personal atomicparsley fdkaac flac ffmpeg lame mediainfo mkvtoolnix-cli optipng opus-tools vorbis-tools"

pkg_personal="$pkg_personal avahi bolt certbot certbot-dns-rfc2136 certbox-nginx distrobox duperemove linux-firmware fwupd hugo python-internetarchive magic-wormhole miniupnpc libnatpmpc openbsd-netcat python-pipx postgresql-libs python-sh rclone speedtest-cli sshuttle syncthing tpm2-tools v4l-utils wireguard-tools wsdd yubico-piv-tool yubikey-manager"

pkg_gui=""

# fonts
pkg_gui="$pkg_gui cantarell-fonts noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra terminus-font ttf-bitstream-vera ttf-cascadia-code ttf-dejavu ttf-fira-code ttf-inconsolata ttf-liberation ttf-roboto ttf-ubuntu-font-family"

pkg_gui="$pkg_gui cups libfido2 flatpak gnome gnome-shell-extensions gnome-terminal gnome-tweaks gst-plugin-libcamera gst-plugin-pipewire gst-plugins-base gst-plugins-good ipp-usb libcamera-ipa libcamera-tools nm-connection-editor pipewire pipewire-audio pipewire-jack pipewire-libcamera pipewire-pulse pipewire-v4l2 pipewire-zeroconf sane-airscan sof-firmware system-config-printer gvim wireplumber xarchiver"

pkg_gui_personal="android-tools android-udev argyllcms deluge-gtk firejail firewalld gst-plugins-bad gst-plugins-ugly mediainfo-gui mpv picard seahorse seahorse-nautilus v4l2loopback-dkms v4l2loopback-utils virt-manager wireshark-qt"

pkg_mesa="clinfo drm-info gstreamer-vaapi mesa-utils vulkan-tools"

pkg_gfx_intel="linux-firmware-intel intel-compute-runtime intel-media-driver vulkan-intel $pkg_mesa"

pkg_gfx_amd="linux-firmware-amdgpu rocm-opencl-runtime vulkan-radeon $pkg_mesa"

pkg_cpu_intel="intel-ucode"

pkg_cpu_amd="amd-ucode"

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


sudo pacman -S -- ${=pkg_core} ${=pkg_core_personal} ${=pkg_gui} ${=pkg_gui_personal} ${=pkg_cpu_amd} ${=pkg_cpu_intel} ${=pkg_gfx_amd} ${=pkg_gfx_intel}
