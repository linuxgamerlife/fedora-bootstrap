#!/usr/bin/env bash
set -euo pipefail

# Fedora Bootstrap Script (TTY friendly)
# Installs: Cinnamon, RPM Fusion, codecs, Steam (RPM), OBS (RPM), Flatpak + Flathub, KDE tools, KWrite
# Removes: GNOME Terminal, GNOME Disks, Thunderbird
# Adds: ffmpeg swap, full GStreamer set, multimedia groups, VA-API bits, Cisco OpenH264, FUSE + Gear Lever,
#       faster boot tweak, Lutris, MangoHud, Podman stack + Podman Desktop, VLC, Audacity, Flatseal, gnome-themes-extra
#
# Run:
#   curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash

echo "Linux Gamer Life Fedora Bootstrap starting..."

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo, for example: sudo bash $0"
  exit 1
fi

FEDORA_VERSION="$(rpm -E %fedora)"
echo "Detected Fedora version: ${FEDORA_VERSION}"

echo "Updating base system..."
dnf -y upgrade --refresh

echo "Installing core utilities..."
dnf -y install curl wget git dnf-plugins-core

echo "Enabling RPM Fusion (free + nonfree)..."
dnf -y install \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

echo "Refreshing repos after RPM Fusion..."
dnf -y upgrade --refresh

echo "Installing Cinnamon Desktop..."
dnf -y install @cinnamon-desktop

echo "Installing and enabling LightDM..."
dnf -y install lightdm lightdm-gtk
systemctl enable lightdm

echo "Removing Thunderbird if present..."
dnf -y remove thunderbird || true

echo "Removing GNOME Terminal and GNOME Disks if present..."
dnf -y remove gnome-terminal gnome-disk-utility || true

echo "Installing KDE tools and KWrite..."
dnf -y install konsole dolphin kde-partitionmanager kwrite

echo "Installing Flatpak and adding Flathub..."
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Replacing ffmpeg-free with ffmpeg (RPM Fusion)..."
dnf -y swap ffmpeg-free ffmpeg --allowerasing || true

echo "Enabling Cisco OpenH264 repo and updating..."
dnf config-manager --set-enabled fedora-cisco-openh264 || true
dnf -y upgrade --refresh

echo "Installing Cisco OpenH264 packages..."
dnf -y install openh264 gstreamer1-plugin-openh264 mozilla-openh264 || true

echo "Installing full GStreamer plugin set..."
dnf -y install \
  "gstreamer1-plugins-bad-*" \
  "gstreamer1-plugins-good-*" \
  gstreamer1-plugins-base \
  gstreamer1-plugin-openh264 \
  gstreamer1-libav \
  "lame*" \
  --exclude=gstreamer1-plugins-bad-free-devel || true

echo "Installing multimedia groups..."
dnf -y group install multimedia || true
dnf -y group install sound-and-video || true

echo "Installing VA-API related packages..."
dnf -y install ffmpeg-libs libva libva-utils

echo "Installing AMD Mesa / Vulkan stack..."
dnf -y install \
  mesa-dri-drivers \
  mesa-vulkan-drivers \
  vulkan-loader \
  mesa-va-drivers \
  mesa-vdpau-drivers \
  linux-firmware

echo "Installing OBS Studio (RPM)..."
dnf -y obs-studio

echo "Installing gaming tools..."
dnf -y install steam
dnf -y install lutris mangohud

echo "Installing VLC (RPM) and Audacity (Flatpak)..."
dnf -y install vlc
flatpak install -y flathub org.audacityteam.Audacity || true

echo "Installing Flatseal (Flatpak)..."
flatpak install -y flathub com.github.tchx84.Flatseal || true

echo "Installing extra themes package..."
dnf -y install gnome-themes-extra

echo "Disabling NetworkManager wait-online for faster boot..."
systemctl disable NetworkManager-wait-online.service || true

echo "Setting graphical boot target..."
systemctl set-default graphical.target

echo "Bootstrap complete. Reboot recommended."
echo "Run: reboot"

