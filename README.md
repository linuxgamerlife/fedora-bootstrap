# Linux Gamer Life Fedora Bootstrap

This script converts a fresh Fedora Everything Minimal install into a fully configured Linux Gamer Life Cinnamon environment.

It is designed to be run from TTY after a minimal Fedora install. One command installs and configures everything automatically.

This creates a consistent, reproducible environment across physical machines, virtual machines, and test systems.

---

## What this installs and configures

### Desktop environment

- Cinnamon desktop
- LightDM display manager

### KDE tools and replacements

These replace several default GNOME and Cinnamon utilities with KDE equivalents:

- Konsole (terminal)
- Dolphin (file manager)
- KDE Partition Manager
- KWrite (text editor)
- Ark (archive manager, replaces File Roller)
- Okular (document viewer, replaces Evince)
- Gwenview (image viewer, replaces Eye of MATE)
- Discover (software manager, replaces GNOME Software)
- Fedora Media Writer

### Multimedia and codec support

Full multimedia capability using RPM Fusion and Cisco OpenH264:

- Full ffmpeg (replaces ffmpeg-free)
- Complete GStreamer plugin set
- Multimedia and sound-and-video groups
- Cisco OpenH264 support
- VA-API acceleration libraries
- Mesa Vulkan and video acceleration stack

### Gaming tools

- Steam (RPM version)
- OBS Studio (RPM version)
- Lutris
- MangoHud

### Proton and compatibility tools

Installed via Flatpak:

- ProtonUp-Qt
- ProtonPlus

These allow easy installation and management of Proton-GE and other compatibility tools.

### Flatpak ecosystem

- Flatpak
- Flathub repository enabled
- Flatseal (Flatpak permissions manager)

### Python and CLI tools

Installed properly using pipx for isolation:

- Python 3
- pipx
- tldr (simplified man pages)
- yt-dlp (media downloader)

These are installed for the user who runs the script.

### System configuration improvements

- RPM Fusion free and non-free repositories enabled
- Cisco OpenH264 repository enabled
- NetworkManager wait-online disabled for faster boot
- Graphical target enabled

---

## What this removes

Removes unwanted default applications to keep the system clean:

### GNOME and Cinnamon apps removed

- Thunderbird
- GNOME Terminal
- GNOME Disks
- GNOME Software
- File Roller
- Document Scanner
- Document Viewer
- Eye of MATE

### Other utilities removed

- HexChat
- Pidgin
- mpv
- Xed
- Xfburn

### Container and AppImage tooling removed

- Podman
- Podman Desktop
- FUSE packages
- Gear Lever

This ensures a lean, gaming-focused environment.

---

## Requirements

Recommended installation method:

- Fedora Everything ISO
- Minimal Install selected
- Boot to TTY login
- Internet connection available

---

## How to run

From TTY, login and run:

```bash
curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash
```

Wait for the script to finish.

Then reboot:

```bash
reboot
```

The system will boot into the Cinnamon desktop.

---

## Recommended installation workflow

1. Install Fedora Everything
2. Select Minimal Install
3. Reboot
4. Login to TTY
5. Run bootstrap command
6. Reboot

Done.

---

## Python tools installed

After installation, you can use:

```bash
tldr dnf
tldr systemctl
yt-dlp URL
```

To update pipx tools later:

```bash
pipx upgrade-all
```

---

## Safety and transparency

View the script source:

https://github.com/linuxgamerlife/fedora-bootstrap

Download and inspect manually if preferred:

```bash
curl -O https://raw.githubusercontent.com/linuxgamerlife/fedora-bootstrap/main/fedora-bootstrap.sh
chmod +x fedora-bootstrap.sh
sudo ./fedora-bootstrap.sh
```

---

## Purpose

This script provides a fast, repeatable, and controlled Fedora deployment optimized for:

- Linux gaming
- Content creation
- Virtual machines
- Testing environments
- Linux Gamer Life workflows

---

## Linux Gamer Life

Part of the Linux Gamer Life ecosystem.

https://github.com/linuxgamerlife
