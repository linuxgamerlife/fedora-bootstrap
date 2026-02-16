# Linux Gamer Life Fedora Bootstrap

This script turns a fresh Fedora installation into a fully configured Linux Gamer Life environment with Cinnamon, gaming tools, multimedia support, Flatpak integration, and essential utilities.

It is designed to be run from a minimal Fedora install that boots to TTY. One command installs and configures everything automatically.

This allows you to reproduce the same environment quickly across physical machines, virtual machines, and test systems.

---

## What this installs and configures

### Desktop
- Cinnamon desktop
- LightDM display manager
- KDE tools:
  - Konsole
  - Dolphin
  - KDE Partition Manager
  - KWrite

### Multimedia support
- Full ffmpeg (replaces ffmpeg-free)
- Complete GStreamer plugin set
- Multimedia and sound-and-video groups
- Cisco OpenH264 codec support
- VA-API acceleration libraries
- VLC media player
- Audacity (Flatpak)
- FUSE and Gear Lever (AppImage support)

### Gaming tools
- Steam (RPM version)
- OBS Studio (RPM version)
- Lutris
- MangoHud

### Container tools
- Podman
- Podman Compose
- Podman Docker compatibility layer
- Podman Desktop (Flatpak)

### Flatpak ecosystem
- Flatpak installed and enabled
- Flathub repository enabled
- Flatseal
- Gear Lever
- Podman Desktop
- Audacity

### System improvements
- Enables RPM Fusion free and non-free repositories
- Enables Cisco OpenH264 repository
- Installs full Mesa Vulkan and VA-API stack
- Disables NetworkManager wait-online for faster boot

### Removes unwanted packages
- Thunderbird
- GNOME Terminal
- GNOME Disks

---

## Requirements

A fresh Fedora installation is recommended.

Recommended method:

- Install Fedora using the **Fedora Everything ISO**
- Select **Minimal Install**
- Boot into **TTY login**

A network connection must be available.

---

## How to run

Login to your Fedora system, then run:

```bash
curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash
```

Wait for the script to complete.

Then reboot:

```bash
reboot
```

After reboot, the system will start into the Cinnamon desktop.

---

## Recommended installation workflow

1. Install Fedora Everything
2. Select Minimal Install
3. Reboot
4. Login to TTY
5. Run the bootstrap command
6. Reboot

Done.

---

## Safety and transparency

This script was developed with the help of AI, is fully open source, and you can inspect it here:

https://github.com/linuxgamerlife/fedora-bootstrap

If you prefer, download and review before running:

```bash
curl -O https://raw.githubusercontent.com/linuxgamerlife/fedora-bootstrap/main/fedora-bootstrap.sh
chmod +x fedora-bootstrap.sh
sudo ./fedora-bootstrap.sh
```

---

## Purpose

This script provides a fast, repeatable, and reliable way to deploy a Fedora gaming and creator environment.

It is especially useful for:

- Fresh installs
- Virtual machines
- Testing environments
- Multi-machine setups
- Linux Gamer Life workflows

---

## Notes

- Designed for clean Fedora installs
- Safe to run multiple times
- Existing packages will be skipped automatically
- Works on Fedora 40, 41, 42, and newer

---

## Linux Gamer Life

Part of the Linux Gamer Life ecosystem.

https://github.com/linuxgamerlife
