# Installing Fedora Everything and Preparing for Linux Gamer Life Bootstrap

This guide explains how to install Fedora Everything and reach a minimal TTY login, ready to run the Linux Gamer Life bootstrap script.

This process gives you a clean, minimal Fedora system that can be fully configured with one command.

## TEST IN A VM FIRST
If you are happy, continue.

---

## Step 1: Download Fedora Everything ISO

Go to the official Fedora download page:

https://fedoraproject.org/misc/#everything 

Scroll down and download:

**Fedora Everything ISO**

Download:

```
Fedora-Everything-netinst-x86_64.iso
```

This is the network installer.

It downloads only what is needed and allows minimal installation.

---

## Step 2: Create a bootable USB

Use you're favourite tool or:

### On Linux

Insert your USB drive and run:

```bash
sudo dd if=Fedora-Everything-netinst-x86_64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Replace `/dev/sdX` with your USB device.

Example:

```bash
sudo dd if=Fedora-Everything-netinst-x86_64.iso of=/dev/sdb bs=4M status=progress oflag=sync
```

Warning: This will erase the USB drive.

---

### On Windows

Use Rufus:

https://rufus.ie

Select:

- Device: Your USB drive
- Boot selection: Fedora Everything ISO
- Click Start

---

## Step 3: Boot from USB

Restart your computer.

Enter the boot menu (usually F12, F11, ESC, or DEL).

Select your USB drive.

Choose:

```
Install Fedora
```

---

## Step 4: Configure installer

The Fedora installer will open.

Set the following:

### Installation Destination

Select your target drive.

Click Done.

---

### Software Selection

This is the most important step.

## LEAVE IT AS DEFAULT

Make sure nothing else is selected.

Do NOT select:

- Fedora Workstation
- Server
- Cinnamon
- KDE
- GNOME

Click Done.

---

### User creation

Create a user account.

Make sure to check:

```
Make this user administrator
```

This allows use of sudo.

---

## Step 5: Begin installation

Click:

```
Begin Installation
```

Wait for installation to complete.

---

## Step 6: Reboot

Click:

```
Reboot System
```

Remove the USB drive if prompted.

---

## Step 7: Login to TTY

You will see a screen like:

```
Fedora Linux 43
login:
```

Enter your username.

Enter your password.

You are now at TTY.

Example:

```
lgl@fedora:~$
```

---

## Step 8: Run the Linux Gamer Life bootstrap script

Run:

```bash
curl -fsSL https://tinyurl.com/lgl-fedora | sudo bash
```

Wait for it to complete.

Then reboot:

```bash
reboot
```

The system will boot into the Cinnamon desktop with full Linux Gamer Life setup.

---

## Summary

Workflow overview:

1. Download Fedora Everything ISO
2. Install Fedora using Custom Install
3. Boot to TTY
4. Run bootstrap script
5. Reboot
6. System ready

---

## Why use Fedora Everything Custom?

Benefits:

- Clean base system
- No unnecessary software
- Faster install
- Fully reproducible setup
- Ideal for scripting and automation

This approach ensures the Linux Gamer Life bootstrap script controls the entire environment.

---
