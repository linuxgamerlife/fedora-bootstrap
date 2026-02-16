#!/usr/bin/env bash
set -euo pipefail

# Linux Gamer Life Fedora Bootstrap (TTY friendly)
# Goal: Start from Fedora Everything Minimal (TTY), run once, reboot into Cinnamon.
#
# Installs and configures:
# - Cinnamon + LightDM
# - RPM Fusion (free + nonfree) + Cisco OpenH264 repo
# - Python tooling: python3, pipx, tldr, yt-dlp (via pipx for the invoking user)
# - Codecs: ffmpeg swap, full GStreamer set, multimedia groups, VA-API bits, OpenH264
# - Gaming: Steam (RPM), OBS (RPM), Lutris, MangoHud
# - Flatpak + Flathub + Flatseal
# - KDE apps on Cinnamon: Konsole, Dolphin, KDE Partition Manager, KWrite
# - Replacements: Ark, Okular, Gwenview, Discover, Fedora Media Writer
#
# Removes:
# - Thunderbird
# - GNOME Terminal
# - GNOME Disks
# - File Roller, Document Scanner, Document Viewer, HexChat, mpv, Pidgin, GNOME Software
# - Xed, Xfburn, Eye of MATE
# - FUSE and Gear Lever (if present)
# - Podman tooling and Podman Desktop (if present)
#
# Tweaks:
# - Disables NetworkManager-wait-online for faster boot
#
# Run:
#   curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash

# -----------------------------
# Colours (LGL style)
# -----------------------------
GREEN='\033[38;2;0;255;0m'     # #00ff00
ORANGE='\033[38;2;255;153;0m'  # #ff9900
RED='\033[38;2;255;68;68m'     # #ff4444
WHITE='\033[38;2;249;249;249m' # #f9f9f9
RESET='\033[0m'
BOLD='\033[1m'

section() { printf "\n${BOLD}${GREEN}==> %s${RESET}\n" "$1"; }
info() { printf "${WHITE}%s${RESET}\n" "$1"; }
warn() { printf "${BOLD}${RED}Warning:${RESET} ${WHITE}%s${RESET}\n" "$1"; }
cmdhint() { printf "${ORANGE}%s${RESET}\n" "$1"; }

require_root() {
  if [[ ${EUID} -ne 0 ]]; then
    warn "Run with sudo, for example:"
    cmdhint "sudo bash $0"
    exit 1
  fi
}

dnf_group_install_best_effort() {
  local group_name="$1"
  dnf -y group install "${group_name}" || true
}

# The user who invoked sudo is who we should configure for pipx installs.
get_target_user() {
  if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
    printf "%s" "${SUDO_USER}"
    return
  fi
  # Fallbacks for edge cases
  printf "%s" "$(logname 2>/dev/null || echo root)"
}

printf "${BOLD}${GREEN}Linux Gamer Life Fedora Bootstrap${RESET}\n"
require_root

TARGET_USER="$(get_target_user)"
FEDORA_VERSION="$(rpm -E %fedora)"
info "Detected Fedora version: ${FEDORA_VERSION}"
info "Target user for user-level tooling: ${TARGET_USER}"

# -----------------------------
# 1) Base system + tooling
# -----------------------------
section "Base update and core tools"
dnf -y upgrade --refresh
dnf -y install curl wget git dnf-plugins-core

# -----------------------------
# 2) Repositories
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
# 3) Desktop environment
# -----------------------------
section "Install Cinnamon and LightDM"
dnf -y install @cinnamon-desktop
dnf -y install lightdm lightdm-gtk
systemctl enable lightdm

# -----------------------------
# 4) Remove packages you do not want
# -----------------------------
section "Remove unwanted packages"

info "Removing mail, chat, and media apps you do not want"
dnf -y remove thunderbird hexchat pidgin mpv || true

info "Removing GNOME tools you do not want"
dnf -y remove gnome-terminal gnome-disk-utility gnome-software || true

info "Removing MATE and Mint style utilities you do not want"
# Eye of MATE is typically packaged as eom
dnf -y remove xed xfburn eom || true

info "Removing File Roller, Document Scanner, and Document Viewer"
# File Roller: file-roller
# Document Scanner: simple-scan
# Document Viewer: evince
dnf -y remove file-roller simple-scan evince || true

# -----------------------------
# 5) KDE utilities and replacements on Cinnamon
# -----------------------------
section "Install KDE utilities and replacements"

info "Core KDE utilities"
dnf -y install konsole dolphin kde-partitionmanager kwrite

info "Replacements for removed apps"
dnf -y install ark okular gwenview

info "KDE Discover (Plasma Discover)"
dnf -y install plasma-discover plasma-discover-packagekit

info "Fedora Media Writer"
dnf -y install mediawriter

# -----------------------------
# 6) Python, pipx, and CLI tools
# -----------------------------
section "Python, pipx, and CLI tools"

info "Installing Python and pipx"
dnf -y install python3 python3-pip pipx

info "Ensuring pipx is ready for the target user"
sudo -u "${TARGET_USER}" pipx ensurepath || true

info "Installing tldr and yt-dlp via pipx for the target user"
sudo -u "${TARGET_USER}" pipx install --include-deps tldr || true
sudo -u "${TARGET_USER}" pipx install --include-deps yt-dlp || true

# -----------------------------
# 7) Multimedia and codecs
# -----------------------------
section "Multimedia and codecs"

info "Replace ffmpeg-free with ffmpeg"
dnf swap -y ffmpeg-free ffmpeg --allowerasing || true

info "Enable OpenH264 packages"
dnf -y install openh264 gstreamer1-plugin-openh264 mozilla-openh264 || true

info "Install all GStreamer plugins"
dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
  gstreamer1-plugin-openh264 gstreamer1-libav lame\* \
  --exclude=gstreamer1-plugins-bad-free-devel || true

info "Install multimedia groups"
dnf_group_install_best_effort "multimedia"
dnf_group_install_best_effort "sound-and-video"

info "Install VA-API related packages"
dnf -y install ffmpeg-libs libva libva-utils

# -----------------------------
# 8) AMD stack (Fedora defaults + extras)
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
# 9) Flatpak + Flathub + Flatpak apps
# -----------------------------
section "Flatpak, Flathub, and Flatpak apps"
dnf -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

info "Flatseal"
flatpak install -y flathub com.github.tchx84.Flatseal || true

info "ProtonUp-Qt"
flatpak install -y flathub net.davidotek.pupgui2 || true

info "ProtonPlus"
flatpak install -y flathub com.vysp3r.ProtonPlus || true

# -----------------------------
# 10) Gaming tools
# -----------------------------
section "Gaming tools"
dnf -y install steam
dnf -y install obs-studio
dnf -y install lutris mangohud
# -----------------------------
# 11) Virtualization (virt-manager and KVM)
# -----------------------------
section "Virtualization (virt-manager and KVM)"

info "Installing KVM, libvirt, and virt-manager"
dnf -y install \
  virt-manager \
  libvirt \
  libvirt-daemon-config-network \
  libvirt-daemon-kvm \
  qemu-kvm \
  virt-install \
  virt-viewer \
  edk2-ovmf \
  swtpm

info "Enabling libvirtd service"
systemctl enable --now libvirtd

info "Adding user to libvirt group"
usermod -aG libvirt "${TARGET_USER}"

info "Virtualization setup complete (reboot required for group changes)"

# -----------------------------
# 12) Boot and system tweaks
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
