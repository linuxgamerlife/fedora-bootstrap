#!/usr/bin/env bash
set -euo pipefail

# Linux Gamer Life Fedora Bootstrap (TTY friendly)
# Goal: start from Fedora Everything minimal (TTY), run once, reboot into Cinnamon.
#
# Installs:
# - Cinnamon + LightDM
# - RPM Fusion (free + nonfree)
# - Codecs + real ffmpeg + GStreamer + multimedia groups + VA-API + Cisco OpenH264
# - Steam (RPM), OBS (RPM), Lutris, MangoHud
# - Flatpak + Flathub + Flatseal + Gear Lever + Audacity + Podman Desktop
# - KDE tools: Konsole, Dolphin, KDE Partition Manager, KWrite
# - Podman core + podman-compose + podman-docker
#
# Removes:
# - Thunderbird, GNOME Terminal, GNOME Disks
#
# Tweaks:
# - Disables NetworkManager-wait-online for faster boot
#
# Run:
#   curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash

# -----------------------------
# Colours (style guide aligned)
# -----------------------------
GREEN='\033[38;2;0;255;0m'     # #00ff00
ORANGE='\033[38;2;255;153;0m'  # #ff9900
RED='\033[38;2;255;68;68m'     # #ff4444
WHITE='\033[38;2;249;249;249m' # #f9f9f9
RESET='\033[0m'
BOLD='\033[1m'

section() {
  printf "\n${BOLD}${GREEN}==> %s${RESET}\n" "$1"
}

info() {
  printf "${WHITE}%s${RESET}\n" "$1"
}

warn() {
  printf "${BOLD}${RED}Warning:${RESET} ${WHITE}%s${RESET}\n" "$1"
}

cmdhint() {
  printf "${ORANGE}%s${RESET}\n" "$1"
}

require_root() {
  if [[ ${EUID} -ne 0 ]]; then
    warn "Run with sudo, for example:"
    cmdhint "sudo bash $0"
    exit 1
  fi
}

dnf_quiet_group_install() {
  local group_name="$1"
  dnf -y group install "${group_name}" || true
}

# -----------------------------
# Start
# -----------------------------
printf "${BOLD}${GREEN}Linux Gamer Life Fedora Bootstrap${RESET}\n"

require_root

FEDORA_VERSION="$(rpm -E %fedora)"
info "Detected Fedora version: ${FEDORA_VERSION}"

# -----------------------------
# Base system + tooling
# -----------------------------
section "System update and base tools"
dnf -y upgrade --refresh
dnf -y install curl wget git dnf-plugins-core

# -----------------------------
# Repositories
# -----------------------------
section "Enable RPM Fusion (free and nonfree)"
dnf -y install \
  "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
  "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

dnf -y upgrade --refresh

section "Enable Cisco OpenH264 repo"
dnf config-manager --set-enabled fedora-cisco-openh264 || true
dnf -y upgrade --refresh

# -----------------------------
# Desktop environment
# -----------------------------
section "Install Cinnamon and LightDM"
dnf -y install @cinnamon-desktop
dnf -y install lightdm lightdm-gtk
systemctl enable lightdm

# -----------------------------
# Remove unwanted defaults
# -----------------------------
section "Remove unwanted packages"
dnf -y remove thunderbird || true
dnf -y remove gnome-terminal gnome-disk-utility || true

# -----------------------------
# KDE utilities on Cinnamon
# -----------------------------
section "Install KDE utilities (Cinnamon-friendly)"
dnf -y install konsole dolphin kde-partitionmanager kwrite

# -----------------------------
# Multimedia and codecs
# -----------------------------
section "Multimedia and codecs"

info "Replace the neutered ffmpeg with the real one"
dnf swap -y ffmpeg-free ffmpeg --allowerasing || true

info "Install all the GStreamer plugins"
dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
  gstreamer1-plugin-openh264 gstreamer1-libav lame\* \
  --exclude=gstreamer1-plugins-bad-free-devel || true

info "Install multimedia groups"
dnf_quiet_group_install "multimedia"
dnf_quiet_group_install "sound-and-video"

info "Install VA-API stuff"
dnf -y install ffmpeg-libs libva libva-utils

info "Install the Cisco codec packages"
dnf -y install openh264 gstreamer1-plugin-openh264 mozilla-openh264 || true

# -----------------------------
# AMD stack (Fedora defaults + extras)
# -----------------------------
section "AMD Mesa and Vulkan stack"
dnf -y install \
  mesa-dri-drivers \
  mesa-vulkan-drivers \
  vulkan-loader \
  mesa-va-drivers \
  mesa-vdpau-drivers \
  linux-firmware

# -----------------------------
# Flatpak + Flathub
# -----------------------------
section "Flatpak and Flathub"
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# -----------------------------
# Gaming
# -----------------------------
section "Gaming tools"
dnf -y install steam
dnf -y install obs-studio
dnf -y install lutris mangohud


# -----------------------------
# Media apps + permissions helper
# -----------------------------
section "Media apps and Flatseal"
dnf -y install vlc
flatpak install -y flathub org.audacityteam.Audacity || true
flatpak install -y flathub com.github.tchx84.Flatseal || true

# -----------------------------
# Extras
# -----------------------------
section "Extra themes"
dnf -y install gnome-themes-extra
dnf -y install fastfetch

# -----------------------------
# Boot tweaks
# -----------------------------
section "Boot and system tweaks"
systemctl disable NetworkManager-wait-online.service || true
systemctl set-default graphical.target

# -----------------------------
# Finish
# -----------------------------
section "Complete"
info "Bootstrap finished."
info "Reboot to start Cinnamon:"
cmdhint "reboot"
