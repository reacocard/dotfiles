#!/bin/zsh
# install many packages i like


pkg_core="ansible ansible-lint apt-file apt-listchanges arj atool build-essential bolt cifs-utils cpio curl firmware-atheros firmware-intel-sound firmware-iwlwifi firmware-linux firmware-misc-nonfree firmware-realtek git htop iftop iotop iperf3 ipython3 jq lbzip2 lshw lsof lzip lzop magic-wormhole mesa-opencl-icd mesa-utils net-tools netcat-traditional nmap p7zip-full pocl-opencl-icd powertop pv rar rsync screen smartmontools smbclient sshfs strace tcpdump telnet thunderbolt-tools tmux traceroute unrar unzip virtualenv vulkan-tools wget whois xdg-utils xz-utils zip zsh zstd"

pkg_personal="borgbackup borgmatic cryptsetup debdelta dnsutils fio fwupd gocryptfs lm-sensors lvm2 mdadm miniupnpc mlocate needrestart sshuttle syncthing tvnamer unattended-upgrades v4l-utils vainfo watchdog wireguard youtube-dl yubico-piv-tool yubikey-manager"

pkg_gui="flatpak fonts-ancient-scripts fonts-cantarell fonts-liberation fonts-mph-2b-damase fonts-roboto fonts-symbola fonts-ubuntu fonts-ubuntu-console gnome-backgrounds gnome-bluetooth gnome-color-manager gnome-disk-utility gnome-keyring gnome-remote-desktop gnome-screenshot gnome-shell gnome-shell-extensions gnome-software gnome-software-plugin-flatpak gnome-terminal gnome-themes-extra gnome-tweaks gstreamer1.0-pipewire gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-pulseaudio gstreamer1.0-tools gstreamer1.0-vaapi gvfs-fuse heif-thumbnailer mplayer mpv nautilus nautilus-extension-burner nautilus-extension-gnome-terminal network-manager-config-connectivity-debian network-manager-gnome network-manager-openvpn-gnome network-manager-pptp-gnome ooo-thumbnailer pavucontrol pipewire pulseaudio-module-bluetooth pulseaudio-utils system-config-printer ttf-bitstream-vera ttf-unifont viewnior vim-gtk3 virt-manager xarchiver xfonts-terminus xwayland"

pkg_gui_personal="cardpeek gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly mcomix plymouth plymouth-themes"

pkg_gfx_intel="beignet-opencl-icd intel-gpu-tools intel-media-va-driver mesa-va-drivers mesa-vulkan-drivers"

pkg_gfx_amd="firmware-amd-graphics mesa-va-drivers mesa-vulkan-drivers"

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


sudo apt install ${=pkg_core} ${=pkg_core_personal} ${=pkg_gui} ${=pkg_gui_personal} ${=pkg_cpu_amd} ${=pkg_cpu_intel} ${=pkg_gfx_amd} ${=pkg_gfx_intel}
