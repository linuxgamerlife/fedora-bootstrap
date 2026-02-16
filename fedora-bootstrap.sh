#!/usr/bin/env bash
set -euo pipefail

# Fedora Bootstrap Script
# Target: Fedora Everything minimal install (TTY)
# Installs Cinnamon, RPM Fusion, codecs, Steam (RPM), OBS (RPM), Flatpak, KDE tools
# Removes unwanted GNOME utilities
# Safe to run multiple times

echo "Fedora Bootstrap starting..."

# Ensure running as root
if [[ $EUID -ne 0 ]]; then
    echo "Please run with sudo"
    exit 1
fi

FEDORA_VERSION=$(rpm -E %fedora)

echo "Detected Fedora version: $FEDORA_VERSION"

echo "Updating system..."
dnf -y upgrade --refresh

echo "Installing core utilities..."
dnf -y install \
    curl \
    wget \
    git \
    fastfetch

echo "Enabling RPM Fusion Free..."
dnf -y install \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm

echo "Enabling RPM Fusion Non-Free..."
dnf -y install \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm

echo "Refreshing repos..."
dnf -y upgrade --refresh

echo "Installing Cinnamon Desktop..."
dnf -y install @cinnamon-desktop

echo "Installing display manager..."
dnf -y install lightdm lightdm-gtk

echo "Enabling LightDM..."
systemctl enable lightdm

echo "Installing multimedia codecs..."
dnf -y install \
    gstreamer1-plugins-base \
    gstreamer1-plugins-good \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugins-bad-freeworld \
    gstreamer1-plugins-ugly \
    gstreamer1-plugin-openh264 \
    ffmpeg \
    ffmpeg-libs

echo "Installing AMD Mesa / Vulkan stack..."
dnf -y install \
    mesa-dri-drivers \
    mesa-vulkan-drivers \
    vulkan-loader \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    linux-firmware

echo "Installing Steam (RPM)..."
dnf -y install steam

echo "Installing OBS Studio (RPM)..."
dnf -y install obs-studio

echo "Installing Flatpak..."
dnf -y install flatpak

echo "Adding Flathub..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing KDE tools..."
dnf -y install \
    konsole \
    dolphin \
    kde-partitionmanager

echo "Removing unwanted GNOME utilities..."
dnf -y remove \
    gnome-terminal \
    gnome-disk-utility || true

echo "Setting graphical boot target..."
systemctl set-default graphical.target

echo "Bootstrap complete."
echo "Reboot recommended."
echo "Run: reboot"
